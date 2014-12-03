# encoding: utf-8
require 'nokogiri'
require 'unicode'
require 'uri'
require 'date'
require 'open-uri'

module FashionCrawler
  module Tasks
    class ZapposProcessAtCate1Page
      def self.execute(url, body)
        doc = Nokogiri::HTML(body)
        begin
          doc.xpath("//div[@class='subnavColumn']//a").each do |link|
            cate_url = "http://www.urbanoutfitters.com" + link
            puts cate_url
            sleep(2)
            FashionCrawler::Models::Resource.create({
              url: cate_url,
              task: 'UrbanoutfittersProcessAtCate2Page',
              is_visited: false,
              site_name: 'Urbanoutfitters',
              store: FashionCrawler::Models::Store.find_by(name: 'Urbanoutfitters')
              })
          end
        rescue => e
          puts e.inspect
          puts e.backtrace
        ensure
          #change the link status
          FashionCrawler::Models::Resource.where(url: url).update_all(is_visited: true)
        end
      end
    end

    class UrbanoutfittersProcessAtCate2Page
      def self.execute(url, body)
        return
        doc = Nokogiri::HTML(body)
        begin
          doc.xpath("//div[@id='FCTzc2Select']//a").each do |link|
            url_cate = "http://www.zappos.com" + link["href"]
            puts "!!!!!!!!!!!!!!!!!!#{url_cate}!!!!!!!!!!!!!!!!!!!!"
            File.open("zappos.text", 'a') do |file|
              file.write "#{url_cate}\n"
            end
          end
        rescue => e
          puts e.inspect
          puts e.backtrace
        ensure
          #change the link status
          FashionCrawler::Models::Resource.where(url: url, ).update_all(is_visited: true)
        end
      end
    end

    # class ZapposProcessAtCate3Page
    #   def self.execute(url, body)
    #     doc = Nokogiri::HTML(body)
    #     begin
    #       puts "----------------#{url}---------------"
    #       doc.xpath("//div[@id='FCTtxattrfacet_stylesSelect']//a").each do |link|
    #         url_cate = "http://www.zappos.com" + link["href"]
    #         puts "!!!!!!!!!!!!!!!!!!#{url_cate}!!!!!!!!!!!!!!!!!!!!"
    #         File.open("zappos.text", 'a') do |file|
    #           file.write "#{url_cate}\n"
    #         end
    #       end
    #     rescue => e
    #       puts e.inspect
    #       puts e.backtrace
    #     ensure
    #       #change the link status
    #       FashionCrawler::Models::Resource.where(url: url, ).update_all(is_visited: true)
    #     end
    #   end
    # end

  end
end
