# encoding: utf-8
require 'nokogiri'
require 'unicode'
require 'uri'
require 'date'

module FashionCrawler
  module Tasks
    class RevolveclothingProcessAtMainPage
     def self.execute(url, body)
      begin
        file_path = File.dirname(__FILE__) + "/static_models/master_db/revolveclothing.yml"
        f = File.open(file_path, "r")
        f.each_line do |line|
          FashionCrawler::Models::Resource.create({
            url: line,
            task: 'RevolveclothingProcessAtCatePage',
            is_visited: false,
            site_name: 'Revolveclothing',
            store: FashionCrawler::Models::Store.find_by(name: 'Revolveclothing')
          })
        end
        f.close
      rescue => e
        puts e.inspect
        puts e.backtrace
      ensure
          #change the link status
          FashionCrawler::Models::Resource.where(url: url).update_all(is_visited: true)
      end
     end
    end

    class RevolveclothingProcessAtCatePage
      def self.execute(url, body)
        doc = Nokogiri::HTML(body)
        begin
          category = url.scan(/category=(\d+)/).join('')
          doc.xpath("//a[@class='plp_text_link']").each do |link|
            if link['href'].present? && link['href'].match(/[A-Z]+-[A-Z]+\d+/)
              detail_url =  "http://www.revolveclothing.com"  + link['href'] + "?category=#{category}"
              unless FashionCrawler::Models::Resource.where(url: detail_url).exists?
                puts "------------------------#{detail_url}-------------------------"
                FashionCrawler::Models::Resource.create({
                  url: detail_url,
                  task: 'RevolveclothingProcessAtDetailPage',
                  is_visited: false,
                  site_name: 'Revolveclothing',
                  store: FashionCrawler::Models::Store.find_by(name: 'Revolveclothing')
                  })
              end
            end
          end
          for i in 2..50 do
            next_link = url + "&pageNum=#{i}"
            FashionCrawler::Models::Resource.create({
            url: next_link,
            task: 'RevolveclothingProcessAtCatePage',
            is_visited: false,
            site_name: 'Revolveclothing',
            store: FashionCrawler::Models::Store.find_by(name: 'Revolveclothing')
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

    class RevolveclothingProcessAtDetailPage
      def self.execute(url, body)
        doc = Nokogiri::HTML(body)
        begin
          url2 = url.gsub(/\?category=(.)*/, "")
          category = url.scan(/category=(\d+)/).join('')
          product = FashionCrawler::Models::Item.where(link: url2).first
          if product.nil?
            item = FashionCrawler::Models::Item.new
            item.link = url2
            name = doc.at_xpath("//div[@class='product_name']//h1")
            item.name = name.text.strip if name.present?

            brand = doc.at_xpath("//div[@class='designer_brand']//h2")
            brand_name = brand.text.strip if brand.present?
            unless brand_name.nil?
              master_brand = MasterBrand.by_brand_name(brand_name)
              unless master_brand.nil?
                item.brand_id = master_brand.brand_id
                item.brand_name = MasterBrand.id_is_other?(item.brand_id) ? brand_name : master_brand.brand_name
                item.brand_name_ja = master_brand.brand_name_ja
              end
            end

            original_price = doc.xpath("//div[@class='price_box']//span[@class='price']").last
            item.original_price = original_price.text.strip if original_price.present?
            if item.original_price.blank?
              original_price = doc.xpath("//div[@class='price_box']//span[@class='original_price']").last
              item.original_price = original_price.text.strip if original_price.present?
            end
            item.original_price

            category = url.scan(/category=(\d+)/).join('')
            item.category_id = category
            master_category = MasterCategory.by_category_3_id(category.to_i)
            unless master_category.nil?
              item.category_name = master_category.category_3
              general_category_id = master_category.general_category_id
            end

            sizes = []
            doc.xpath("//div[@class='pdp_sizes']//li//a").each do |link|
              sizes << link.text.strip
            end

            unless sizes.empty?
              item.original_size = sizes.join(",").gsub("all", "Onesize")
              if general_category_id.nil?
                item.size = item.original_size
              else
                item.size = MasterSize.convert_sizes(item.original_size, "US", general_category_id)
              end
            end

            item.flag = 0
            unless item.size.match(/OUT OF STOCK/)
              item.flag = 1
              item.number_of_products = 3
            end

            item.site_id = 11
            item.site_name = "Revolveclothing"
            item.country_name = "US"
          else
            item = product
          end

          description = doc.at_xpath("//div[@class='pdp_product_info_panel active']")
          item.description = description.text.strip unless description.nil?

          images= []
          doc.xpath("//div[@class='pdp_main_img_thumbs']//img").each do |img|
            img_tmp = img["src"].to_s.gsub(/dt/, "z")
            images << img_tmp
          end
          item.images = images.join(",")

          if item.name.present? && item.brand_name.present? && item.original_price.present?
            item.save!
            puts "added #{item.name}"
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
  end
end
