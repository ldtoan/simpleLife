# encoding: utf-8
require 'nokogiri'
require 'unicode'
require 'uri'
require 'date'
require 'open-uri'

module FashionCrawler
  module Tasks
    class RomweProcessAtMainPage
      def self.execute(url, body)
        begin
          list_cate = ["http://www.romwe.com/Maxi-Dresses-c-38_64_464.html?category=146",
          "http://www.romwe.com/Floral-Dresses-c-38_64_452.html?category=144",
          "http://www.romwe.com/Bodycon-Dress-c-38_64_449.html?category=148",
          "http://www.romwe.com/Lace-Dress-c-38_64_461.html?category=144",
          "http://www.romwe.com/Print-Dresses-c-38_64_522.html?category=144",
          "http://www.romwe.com/Shift-Dresses-c-38_64_523.html?category=144",
          "http://www.romwe.com/Little-Black-Dresses-c-38_64_528.html?category=144",
          "http://www.romwe.com/apparel-spring-dress-c-38_292.html?category=144",
          "http://www.romwe.com/apparel-shirt-blouse-c-38_63.html?category=10",
          "http://www.romwe.com/apparel-tshirt-c-38_62.html?category=2",
          "http://www.romwe.com/apparel-skirt-c-38_65.html?category=15",
          "http://www.romwe.com/apparel-shorts-c-38_128.html?category=18",
          "http://www.romwe.com/apparel-swimwear-c-38_157.html?category=132",
          "http://www.romwe.com/apparel-bralets-c-38_210.html?category=350",
          "http://www.romwe.com/apparel-leggings-c-38_45.html?category=113",
          "http://www.romwe.com/apparel-tights-c-38_37.html?category=114",
          "http://www.romwe.com/apparel-pants-c-38_66.html?category=17",
          "http://www.romwe.com/apparel-vest-basic-c-38_69.html?category=13",
          "http://www.romwe.com/apparel-hoodiessweatshirts-c-38_167.html?category=9",
          "http://www.romwe.com/apparel-cardigansjumpers-c-38_67.html?category=7",
          "http://www.romwe.com/apparel-jackets-c-38_163.html?category=47",
          "http://www.romwe.com/apparel-coats-c-38_48.html?category=57",
          "http://www.romwe.com/apparel-suits-c-38_68.html?category=154",
          "http://www.romwe.com/accessories-bags-c-36_59.html?category=85",
          "http://www.romwe.com/accessories-shoes-c-36_104.html?category=67",
          "http://www.romwe.com/accessories-boots-c-36_169.html?category=76",
          "http://www.romwe.com/accessories-sunglasses-c-36_145.html?category=100",
          "http://www.romwe.com/accessories-scarvessnoods-c-36_135.html?category=120",
          "http://www.romwe.com/accessories-hats-c-36_134.html?category=103",
          "http://www.romwe.com/accessories-belts-c-36_146.html?category=109",
          "http://www.romwe.com/jewelry-necklace-c-39_42.html?category=90",
          "http://www.romwe.com/jewelry-ring-c-39_43.html?category=92",
          "http://www.romwe.com/jewelry-earring-c-39_41.html?category=91",
          "http://www.romwe.com/jewelry-bracelet-c-39_44.html?category=93",
          "http://www.romwe.com/jewelry-brooch-c-39_40.html?category=119",
          "http://www.romwe.com/iphone-accessories-iphone-cases-c-239_240.tml?category=111",
          "http://www.romwe.com/iphone-accessories-iphone-screen-protector-c-239_242.html?category=111",
          "http://www.romwe.com/iphone-accessories-iphone-dock-and-cable-c-239_244.html?category=111",
          "http://www.romwe.com/iphone-accessories-iphone-speaker-c-239_246.html?category=111",
          "http://www.romwe.com/iphone-accessories-iphone-earphone-c-239_247.html?category=111",
          "http://www.romwe.com/iphone-accessories-iphone-gadgets-c-239_251.html?category=111",
          "http://www.romwe.com/iphone-accessories-iphone-touch-glove-c-239_252.html?category=111"]

          list_cate.each do |link|
            FashionCrawler::Models::Resource.create({
              url: link.to_s,
              task: 'RomweProcessAtCatePage',
              is_visited: false,
              site_name: 'Romwe',
              store: FashionCrawler::Models::Store.find_by(name: 'Romwe')
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


    class RomweProcessAtCatePage
      def self.execute(url, body)
         doc = Nokogiri::HTML(body)
         begin
          category = url.scan(/category=(\d+)/).join("")
            body.scan(/\/([\w-]+p-\d+.html)/).each do |link|
              detail_url = "http://www.romwe.com/" + link.first.to_s + "?category=#{category}"
               unless FashionCrawler::Models::Resource.where(url: detail_url).exists?
                puts "!!!!!!!!!!!!#{detail_url}!!!!!!!!!!"
                FashionCrawler::Models::Resource.create({
                url: detail_url,
                task: 'RomweProcessAtDetailPage',
                is_visited: false,
                site_name: 'Romwe',
                store: FashionCrawler::Models::Store.find_by(name: 'Romwe')
                })
               end
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

    class RomweProcessAtDetailPage
      def self.execute(url, body)
        doc = Nokogiri::HTML(body)
        begin
          url2 = url.gsub(/\?category=(.)*/, "")
          product = FashionCrawler::Models::Item.where(link: url2).first
          if product.nil?

            item = FashionCrawler::Models::Item.new
            item.link = url2
            name = doc.at_xpath("//p[@class='model-title']")
            item.name = name.text.strip unless name.nil?
            brand_name = 'Romwe'

            unless brand_name.nil?
              master_brand = MasterBrand.by_brand_name(brand_name)
              unless master_brand.nil?
                item.brand_id = master_brand.brand_id
                item.brand_name = MasterBrand.id_is_other?(item.brand_id) ? brand_name : master_brand.brand_name
                item.brand_name_ja = master_brand.brand_name_ja
              end
            end

            item.site_id = 15
            item.site_name = "Romwe"
          else
            item = product
          end

          description = doc.at_xpath("//p[@class='info']")
          item.description = description.text if description.present?

          original_price = doc.at_xpath("//span[@class='productSpecialPrice']")
          original_base_price = doc.at_xpath("//span[@class='normalprice']")
          unless original_price.present?
            original_price = doc.at_xpath("//span[@class='productSalePrice']")
          end

          if original_price.present?
            item.original_price = original_price.text
            item.price = CurrencyRate.convert_price_to_yen("USD", item.original_price, "$")
          end

          if original_base_price.present?
            item.original_base_price = original_base_price.text
            item.base_price = CurrencyRate.convert_price_to_yen("USD", item.original_base_price, "$")
          end

          images = []
          doc.xpath("//div[@class='smallimgbox fl']//img").each do |img|
            images << img["src"].gsub(/small_image\//, "") if img["src"].present?
          end
          item.images = images.join(",")

          category = url.scan(/\?category=(\d+)/).join('')
          item.category_id = category
          master_category = MasterCategory.by_category_3_id(category.to_i)
          unless master_category.nil?
            item.category_name = master_category.category_3
            general_category_id = master_category.general_category_id
          end

          number_of_products = 0
          product_id = url.scan(/p-(\d+).html/).join('')
          sizes = item.description.scan(/taken from size (\S+)/).join('').gsub(/,$/, "")
          url_request = "http://www.romwe.com/showkucun.php?products_id=#{product_id}&door=1"
          number_of_products = open(url_request).read.to_i

          if number_of_products > 0
             item.flag = 1
             item.number_of_products = number_of_products
          else
             item.flag = 0
          end

          unless sizes.empty?
            item.original_size = sizes
            if general_category_id.nil?
              item.size = item.original_size
            else
              item.size = MasterSize.convert_sizes(item.original_size, "US", general_category_id)
            end
          end

          if item.size == "One Size" || item.size == "No Size"
            number_of_products = 3
          end

          if number_of_products > 0
             item.flag = 1
             item.number_of_products = number_of_products
          else
             item.flag = 0
          end

          if item.name.present? && item.price.present? && category.to_i > 0 && item.flag == 1
            item.save!
            puts "added #{item.name}"
          end

        rescue => e
          FashionCrawler::Models::Resource.where(url: url).update_all(is_visited: true)
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
