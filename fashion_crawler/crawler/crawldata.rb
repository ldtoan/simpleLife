require 'rubygems'
require 'mongo'
require 'json'
require 'mongoid'

Dir[File.expand_path(File.dirname(__FILE__)) + '/../models/mongoid/*.rb'].each {|file| require file }
Mongoid.load!(File.expand_path(File.dirname(__FILE__)) + '/config/mongoid.yml', :production)


   #FashionCrawler::Models::Resource.delete_all()
   #FashionCrawler::Models::Job.where(url: url).delete_all

   sites = JSON.parse(open(File.expand_path(File.dirname(__FILE__)) + "/config/crawler_config.json").read)
   unless FashionCrawler::Models::Store.where(name: sites['data'][0][0]['site_name']).exists?
          FashionCrawler::Models::Store.create!({
          name: sites['data'][0][0]['site_name'],
          url:  sites['data'][0][0]['url'],
          hourly_limit: 2000
          })
   end

   unless FashionCrawler::Models::Resource.where(url: sites['data'][0][0]['start_url']).exists?
          FashionCrawler::Models::Resource.create({
            url: sites['data'][0][0]['start_url'],
            task: sites['data'][0][0]['task'],
            is_visited: false,
            store: FashionCrawler::Models::Store.find_by(name: sites['data'][0][0]['site_name'])
            })
   end