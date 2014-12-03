# coding: utf-8

require 'singleton'
require 'eventmachine'
require 'em-http-request'

require 'yaml'

app_path = File.dirname(__FILE__).gsub("/fashion_crawler/crawler", "")
require 'mongoid'
require File.expand_path(File.dirname(__FILE__)) + '/fetcher'
require File.expand_path(File.dirname(__FILE__)) + '/my-logger.rb'
Dir[File.expand_path(File.dirname(__FILE__)) + '/tasks/**/*.rb'].each {|file| require file }
require File.expand_path(File.dirname(__FILE__)) + '/reporter.rb'
require File.expand_path(File.dirname(__FILE__)) + '/mail_info.rb'
Dir[File.expand_path(File.dirname(__FILE__)) + '/../models/mongoid/*.rb'].each {|file| require file }
include Report
#
# import mongoid config
#
Mongoid.load!(File.expand_path(File.dirname(__FILE__)) + '/config/mongoid.yml', :production)

module FashionCrawler
  class CrawlManager
    include Singleton
    @@interval = 1.0
    @@min_queue_size = 10
    @@queue_offset = 0

    # init function for JP crawling with specific group
    def init_link_of_group(group_id)
      check_running_start = check_running_end = -1
      status = group_id
      sites = JSON.parse(open(File.expand_path(File.dirname(__FILE__)) + "/config/crawler_config.json").read)
      sites['data'][status].each do |site|
        if FashionCrawler::Models::Store.where(name: site['site_name']).exists?
          while FashionCrawler::Models::Store.where(name: site['site_name']).first.importing == true
            puts "Waiting importing to MySql..."
            sleep(150)
          end
        end
      end
      sites['data'][status].each do |site|
        check_running_start = check_running_start + FashionCrawler::Models::Resource.where(site_name: site['site_name'], is_visited: false ).count
      end
      puts "start" + check_running_start.to_s

      if check_running_start != -1
        puts "Checking have any other crawlers running, please wait 30s................."
        sleep(30)
        sites['data'][status].each do |site|
          check_running_end = check_running_end + FashionCrawler::Models::Resource.where(site_name: site['site_name'], is_visited: false ).count
        end
        puts "end" + check_running_end.to_s
      end

      if check_running_start == -1

        puts "Preparing crawler group index: #{status}"
        sites['data'][status].each do |site|
          if FashionCrawler::Models::Store.where(name: site['site_name']).exists?
            FashionCrawler::Models::Store.where(name: site['site_name']).update_all(crawling: true)
          else
            puts "add site " + site['site_name'] + " to STORE"
            FashionCrawler::Models::Store.create!({
              name: site['site_name'],
              url:  site['url'],
              hourly_limit: 2000,
              site_id: site['site_id'],
              crawling: true
              })
          end
          if FashionCrawler::Models::Resource.where(site_name: site['site_name']).exists?
            puts "deleting all resources follow site_id: #{site['site_id']} site_name: #{site['site_name']} in resource"
            FashionCrawler::Models::Resource.where(site_name: site['site_name']).delete_all
            sleep(10)
          end
          FashionCrawler::Models::Item.where(site_id: site['site_id']).update_all(added_or_updated: false)
          sleep(30)
          unless FashionCrawler::Models::Resource.where(url: site['start_url']).exists?
            FashionCrawler::Models::Resource.create({
              url: site['start_url'],
              task: site['task'],
              is_visited: false,
              site_name: site['site_name'],
              store: FashionCrawler::Models::Store.find_by(name: site['site_name'])
              })
          end
        end
      elsif check_running_start == check_running_end
        puts "Continue the last time crawling ........"
        sleep(5)
      else
        puts "Have a other crawler task running, this task stop !!!!!!"
        exit
      end
    end

    def setup
      if ARGV[0].nil?
        init_link()
      else
        $sites = JSON.parse(open(File.expand_path(File.dirname(__FILE__)) + "/config/crawler_config.json").read)
        $status = ARGV[0].to_i
        init_link_of_group(ARGV[0].to_i)
      end

      puts "Create indexes ..."
      FashionCrawler::Models::CrawlLog.create_indexes
      FashionCrawler::Models::Resource.create_indexes
      FashionCrawler::Models::Store.create_indexes
    end

    #=== crawl run
    def run

      # init
      puts "Starting time"
      puts Time.now
      setup()

      # get fetcher instannce
      @fetcher = FashionCrawler::Fetcher.instance

      EM.run do
        EM.add_periodic_timer(@@interval) do
          periodic()
          if ARGV[0].nil?
            EM.stop_event_loop unless FashionCrawler::Models::Resource.where(is_visited: false).exists?
          else
            # this is run if crawling with specific group
            count = 0
            $sites['data'][$status].each do |site|
              count = count + FashionCrawler::Models::Resource.where(site_name: site['site_name'], is_visited: false ).count
            end
            if count == 0
              puts "Finish crawling this group " + $status.to_s
              EM.stop_event_loop
            end
          end
        end
      end

      # this is run if crawling with specific group
      if !ARGV[0].nil?
        puts "copy jobs"
        status = ARGV[0].to_i
        sites = JSON.parse(open(File.expand_path(File.dirname(__FILE__)) + "/config/crawler_config.json").read)
        #### Copy all data from jobs crawling table to jobs table

        sites['data'][status].each do |site|

          if FashionCrawler::Models::Resource.where(site_name: site['site_name']).exists?
            puts "deleting all resources follow site_id: #{site['site_id']} site_name: #{site['site_name']} in resource"
            FashionCrawler::Models::Resource.where(site_name: site['site_name']).delete_all
            sleep(10)
          end

          unless FashionCrawler::Models::Item.where(site_id: site['site_id'], added_or_updated: true).exists?
            puts "Sending email notification"
            send_email(site['site_name'], status.to_s)
          end

          FashionCrawler::Models::Item.where(site_id: site['site_id'], added_or_updated: false).delete_all
          sleep(10)

          FashionCrawler::Models::Store.where(name: site['site_name']).update_all(crawling: false)
          puts "End time"
          puts Time.now
        end

      end

    end

    # periodic function
    def periodic
      # get current length of fetcher queue
      queue_length = @fetcher.queue.length
      # if queue length size is smaller than min_queue_size
      # Log.info "#{queue_length} < #{@@min_queue_size}"
      if queue_length < @@min_queue_size
        # todo = {resource, store}
        todos = []
        FashionCrawler::Models::Store.each do |store|

          #parallel_request_limit = store.parallel_request_limit
          parallel_request_limit = 100

          requesting_count = @fetcher.queue.select{|q| q[:store_name] == store.name }.length

          next if parallel_request_limit == requesting_count

          # count = store.resources.order_by(:last_access.asc).limit(parallel_request_limit - requesting_count).count
          #Log.info "#{store.name} [#{requesting_count} / #{parallel_request_limit}]"

          if parallel_request_limit == 0
            store.update_attributes!({
              hourly_limit: 0,
              parallel_request_limit: 0
              })
          end

          #store.resources.order_by(:last_access.asc).limit(parallel_request_limit - requesting_count).offset(@@queue_offset).each do |res|
          if ARGV[0].nil?  # when run automatically
            store.resources.where(is_visited: false).limit(parallel_request_limit - requesting_count).offset(@@queue_offset).each do |res|

              if @fetcher.queue.select{|q| q[:url] == res.url }.length > 0 ||
                @fetcher.requesting.select{|url| url == res.url }.length > 0
                next
              end
              todos << {resource: res, store: store}
            end
          else
            $sites['data'][$status].each do |site|
              store.resources.where(site_name: site['site_name'], is_visited: false).limit(parallel_request_limit - requesting_count).offset(@@queue_offset).each do |res|
                if @fetcher.queue.select{|q| q[:url] == res.url }.length > 0 ||
                  @fetcher.requesting.select{|url| url == res.url }.length > 0
                  next
                end
                todos << {resource: res, store: store}
              end
            end
          end
        end

        todos.each{ |todo|
          @fetcher.add_queue(todo[:resource].url, todo[:store].name, todo[:resource].detail){ |url, body|
            FashionCrawler::Tasks.module_eval %Q{
              begin
                if todo[:resource].task.start_with?('LuisaViaRoma')
                  #{todo[:resource].task}.new(url, body).execute
                else
                  #{todo[:resource].task}.execute(url, body)
                end
              rescue Exception => err
                Log.error err
              end
            }
          }
        }

      end

      @fetcher.fetch

    rescue Exception => err
      Log.error err
    rescue NoMethodError => err
      Log.error err
    end

  end
end
