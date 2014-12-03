# encoding: utf-8
require 'nokogiri'
require 'unicode'
require 'uri'
require 'date'

CATEGORIES_KARMALOOP = ["clothing", "footwear", "accessories", "beauty"]
NOCRAWLING_KARMALOOP = ["womens/clothing/dresses/sweater", "womens/clothing/sweatshirts/jackets", "womens/footwear/shoes/lace-up", "womens/beauty/makeup/body", "womens/beauty/makeup/lips", "womens/beauty/makeup/nails", "mens/accessories/grooming-fragrance/shave", "womens/accessories/bags/Duffle-Bags", "womens/accessories/hats/Dress-Hats", "womens/accessories/bags/duffle-bags", "womens/accessories/hats/dress-hats"]
module FashionCrawler
  module Tasks
    class KarmaloopProcessAtMainPage
     def self.execute(url, body)
      begin
        ["http://www.karmaloop.com/browse/mens?Pgroup=1", "http://www.karmaloop.com/browse/womens?Pgroup=2"].each do |link|
        FashionCrawler::Models::Resource.create({
          url: link,
          task: 'KarmaloopProcessAtCatePage',
          is_visited: false,
          site_name: 'Karmaloop',
          store: FashionCrawler::Models::Store.find_by(name: 'Karmaloop')
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


    class KarmaloopProcessAtCatePage
      def self.execute(url, body)
        doc = Nokogiri::HTML(body)
        begin

          doc.xpath("//*[@class='collapsable-container category-list']//a").each do |link|
            unless link['href'].nil?
              match = false
              CATEGORIES_KARMALOOP.each do |category|
                match = true if link['href'].match(category)
              end
              if match == true
                category_url = link['href']
                unless FashionCrawler::Models::Resource.where(url: category_url).exists?
                  FashionCrawler::Models::Resource.create({
                    url: category_url,
                    task: 'KarmaloopProcessAtCatePage1',
                    is_visited: false,
                    site_name: 'Karmaloop',
                    store: FashionCrawler::Models::Store.find_by(name: 'Karmaloop')
                    })
                end
              end
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

    class KarmaloopProcessAtCatePage1
      def self.execute(url, body)
        doc = Nokogiri::HTML(body)
        begin
          doc.xpath("//*[@class='collapsable-container category-list']//*[contains(concat(' ', @class, ' '), ' category-node inactive-node ')]/a").each do |link|
            if !link['href'].nil?
              category_url = link['href'].gsub(/\?Pdept(.)*/, "")
              match = false
              CATEGORIES_KARMALOOP.each do |category|
                match = true if category_url.match(category)
              end
              if match == true
                unless FashionCrawler::Models::Resource.where(url: category_url).exists?
                  FashionCrawler::Models::Resource.create({
                    url: category_url,
                    task: 'KarmaloopProcessAtCatePage2',
                    is_visited: false,
                    site_name: 'Karmaloop',
                    store: FashionCrawler::Models::Store.find_by(name: 'Karmaloop')
                    })
                end
              end
            end
          end

          doc.xpath("//*[@class='collapsable-container category-list']//*[contains(concat(' ', @class), ' category-node  node')]/a").each do |link|
            if !link['href'].nil?
              category_url = link['href'].gsub(/\?Pdept(.)*/, "")
              match = false
              CATEGORIES_KARMALOOP.each do |category|
                match = true if category_url.match(category)
                next
              end
              NOCRAWLING_KARMALOOP.each do |category|
                match = false if category_url.match(category)
              end
              if match == true
                unless FashionCrawler::Models::Resource.where(url: category_url).exists?
                  FashionCrawler::Models::Resource.create({
                    url: category_url,
                    task: 'KarmaloopProcessAtPagingPage',
                    is_visited: false,
                    site_name: 'Karmaloop',
                    store: FashionCrawler::Models::Store.find_by(name: 'Karmaloop')
                    })
                end
              end
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

    class KarmaloopProcessAtCatePage2
      def self.execute(url, body)
        doc = Nokogiri::HTML(body)
        begin
          category = url.gsub("http://www.karmaloop.com/browse/", "")
          doc.xpath("//*[contains(concat(' ', @class), ' category-node selected-node node')]//a").each do |link|
            if !link['href'].nil? && link['href'].match(category)
              category_url = link['href'].gsub(/\?Pdept(.)*/, "")
              match = true
              NOCRAWLING_KARMALOOP.each do |category|
                match = false if category_url.match(category)
              end
              if match == true
                unless FashionCrawler::Models::Resource.where(url: category_url).exists?
                  FashionCrawler::Models::Resource.create({
                    url: category_url,
                    task: 'KarmaloopProcessAtPagingPage',
                    is_visited: false,
                    site_name: 'Karmaloop',
                    store: FashionCrawler::Models::Store.find_by(name: 'Karmaloop')
                    })
                end
              end
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


    class KarmaloopProcessAtPagingPage
      def self.execute(url, body)
        doc = Nokogiri::HTML(body)
        begin

          category = url.gsub("http://www.karmaloop.com/browse/", "").gsub(/\?(.)*/, "")

          doc.xpath("//*[@id='products-list']//a").each do |link|
            if link['href'].present? && link['href'].match("/product/")
              detail_url = "#{link['href']}?tmp=#{category}"
              unless FashionCrawler::Models::Resource.where(url: detail_url).exists?
                FashionCrawler::Models::Resource.create({
                url: detail_url,
                task: 'KarmaloopProcessAtDetailPage',
                is_visited: false,
                site_name: 'Karmaloop',
                store: FashionCrawler::Models::Store.find_by(name: 'Karmaloop')
                })
              end
            end
          end

          doc.xpath("//*[@class='pages']//a").each do |link|
            if link['href'].present?
              paging_url = link['href'].gsub(/Pdept(.)*PageNumber/, "PageNumber").gsub(/&PageSize(.)*/, "").downcase
              unless FashionCrawler::Models::Resource.where(url: paging_url).exists?
                FashionCrawler::Models::Resource.create({
                url: paging_url,
                task: 'KarmaloopProcessAtPagingPage',
                is_visited: false,
                site_name: 'Karmaloop',
                store: FashionCrawler::Models::Store.find_by(name: 'Karmaloop')
                })
              end
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

    class KarmaloopProcessAtDetailPage
      def self.execute(url, body)
        doc = Nokogiri::HTML(body)
        begin
          url2 = url.gsub(/\?tmp=(.)*/, "")
          product = FashionCrawler::Models::Item.where(link: url2).first
          if product.nil?
            item = FashionCrawler::Models::Item.new
            item.link = url2
            name = doc.at_xpath("//*[@id='title']")
            item.name = name.text.strip unless name.nil?
            brand = doc.at_xpath("//a[@id='brand']")
            unless brand.nil?
              brand = brand.text.strip
              master_brand = MasterBrand.by_brand_name(brand)
              unless master_brand.nil?
                item.brand_id = master_brand.brand_id
                item.brand_name = MasterBrand.id_is_other?(item.brand_id) ? brand : master_brand.brand_name
                item.brand_name_ja = master_brand.brand_name_ja
              end
            end
            item.site_id = 9
            item.site_name = "Karmaloop"
            item.country_name = "US"
          else
            item = product
          end

          description = doc.at_xpath("//*[@itemprop='description']")
          item.description = description.text.strip unless description.nil?

          price = doc.at_xpath("//*[@itemprop='price']")
          unless price.nil?
            item.original_price = price.text.strip
            item.price = CurrencyRate.convert_price_to_yen("USD", item.original_price, "$")
          end

          base_price = doc.at_xpath("//*[@class='discount-off']")
          unless base_price.nil?
            item.original_base_price = base_price.text.strip
            item.base_price = CurrencyRate.convert_price_to_yen("USD", item.original_base_price, "$")
          end

          image_nodes = []
          doc.xpath("//*[@id='thumbs']//img").each do |node|
            image_nodes << node['src']
          end
          item.images = image_nodes.join(",")

          category = url.scan(/(\?tmp=(.)+)/).join('')
          category = category.gsub("?tmp=","")[0..-2]
          item.category_id = KarmaloopCategory.by_name(category).category_id
          master_category = MasterCategory.by_category_3_id(item.category_id.to_i)
          unless master_category.nil?
            item.category_name = master_category.category_3
            general_category_id = master_category.general_category_id
          end

          sizes = []
          doc.xpath("//*[@id='sizes']//*[@class='size']").each do |node|
            size = node.text.strip
            sizes << size
          end
          unless sizes.empty?
            item.original_size = sizes.join(",")
            if general_category_id.nil?
              item.size = item.original_size
            else
              item.size = MasterSize.convert_sizes(item.original_size, "US", general_category_id)
            end
          end

          parse_size = doc.xpath("//ol[@id='sizes']//a[@class='size']")
          if parse_size.present?
            number_of_products = 0
            parse_size.each do |kamarloop|
              number_of_products += kamarloop.attributes["data-skuqty"].value.to_i if kamarloop.attributes.present? && kamarloop.attributes['data-skuqty'].present?
            end

            if number_of_products > 0
            item.flag = 1
            item.number_of_products = number_of_products
            else
              item.flag = 0
            end

          end


          if item.name.present? && item.brand_name.present? && item.price.present?
            item.save!
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
