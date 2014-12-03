# encoding: utf-8
require 'nokogiri'
require 'unicode'
require 'uri'
require 'date'

module FashionCrawler
  module Tasks
    class LystProcessAtMainPage
     def self.execute(url, body)
      doc = Nokogiri::HTML(body)
      begin
        FashionCrawler::Models::Resource.create({
          url: "http://www.lyst.com/shop/womens/",
          task: 'LystProcessAtCatePage',
          is_visited: false,
          site_name: 'Lyst',
          store: FashionCrawler::Models::Store.find_by(name: 'Lyst')
          })
        FashionCrawler::Models::Resource.create({
          url: "http://www.lyst.com/shop/mens/",
          task: 'LystProcessAtCatePage',
          is_visited: false,
          site_name: 'Lyst',
          store: FashionCrawler::Models::Store.find_by(name: 'Lyst')
          })
      rescue => e
        puts e.inspect
        puts e.backtrace
      ensure
          #change the link status
          FashionCrawler::Models::Resource.where(url: url).update_all(is_visited: true)
        end
      end
    end

    class LystProcessAtCatePage
      def self.execute(url, body)
        doc = Nokogiri::HTML(body)
        begin
          doc.xpath("//*[@class='subcategories']//a").each do |link|
            parent = doc.at_xpath(link.path + "/parent::h3")
            if parent.nil? && !link['href'].nil?
              category_url = "http://www.lyst.com#{link['href']}"
              unless FashionCrawler::Models::Resource.where(url: category_url).exists?
                FashionCrawler::Models::Resource.create({
                url: category_url,
                task: 'LystProcessAtPagingPage',
                is_visited: false,
                site_name: 'Lyst',
                store: FashionCrawler::Models::Store.find_by(name: 'Lyst')
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

    class LystProcessAtPagingPage
      def self.execute(url, body)
        doc = Nokogiri::HTML(body)
        begin

          base_url = url.gsub(/\?category(.)*/,"")
          if url.include?("&tmp")
            category = url.scan(/(&tmp=(.)+)/).join('')
            category = category.gsub("&tmp=","")[0..-2]
          else
            category = url.gsub("http://www.lyst.com/shop/", "").gsub("/", "")
          end

          doc.xpath("//a").each do |link|
            if !link['href'].nil? && link['href'].match(/&start=[\d]+/)
              paging_url = "#{base_url}#{link['href']}&tmp=#{category}"
              unless FashionCrawler::Models::Resource.where(url: paging_url).exists?
                FashionCrawler::Models::Resource.create({
                url: paging_url,
                task: 'LystProcessAtPagingPage',
                is_visited: false,
                site_name: 'Lyst',
                store: FashionCrawler::Models::Store.find_by(name: 'Lyst')
                })
              end
            end
          end

          doc.xpath("//*[@class='product-details']/a").each do |link|
            unless link['href'].nil?
              detail_url = "http://www.lyst.com#{link['href']}?tmp=#{category}"
              unless FashionCrawler::Models::Resource.where(url: detail_url).exists?
                FashionCrawler::Models::Resource.create({
                url: detail_url,
                task: 'LystProcessAtDetailPage',
                is_visited: false,
                site_name: 'Lyst',
                store: FashionCrawler::Models::Store.find_by(name: 'Lyst')
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

    class LystProcessAtDetailPage
      def self.execute(url, body)
        doc = Nokogiri::HTML(body)
        begin

          check_farfetch = doc.xpath("//span[@class='retailer-name']")
          check_farfetch = check_farfetch.present? ? check_farfetch.text : ""

          unless check_farfetch.downcase.include?("farfetch")
          url2 = url.gsub(/\?tmp=(.)*/, "")
          product = FashionCrawler::Models::Item.where(link: url2).first
          if product.nil?
            item = FashionCrawler::Models::Item.new
            item.link = url2

            name = doc.at_xpath("//*[@id='product-content']//*[@itemprop='name']")
            item.name = name.text.strip unless name.nil?

            brand = doc.at_xpath("//*[@id='product-content']//*[@itemprop='brand']")
            unless brand.nil?
              brand = brand.text.strip
              master_brand = MasterBrand.by_brand_name(brand)
              unless master_brand.nil?
                item.brand_id = master_brand.brand_id
                item.brand_name = item.brand_id == 100000 ? brand : master_brand.brand_name
                item.brand_name_ja = master_brand.brand_name_ja.nil? ? "" : master_brand.brand_name_ja
              end
            end

            item.site_id = 3
            item.site_name = "LYST"
          else
            item = product
          end

          item.colors = Color.crawler_extract_color_name(item.name) unless item.name.nil?

          description = doc.at_xpath("//*[@id='product-content']//*[@itemprop='description']")
          item.description = description.text.strip unless description.nil?

          original_price = doc.at_xpath("//*[@class='productPrice']//*[@class='price old-price']")
          unless original_price.nil?
            item.original_base_price = original_price.text.strip
            original_base_price = item.original_base_price.gsub("$","").gsub(",", "").to_f
            item.base_price = CurrencyRate.convert_to_yen("USD", original_base_price) if original_base_price != 0
          end

          price = doc.at_xpath("//*[@id='product-content']//*[@itemprop='price']")
          unless price.nil?
            item.original_price = price.text.strip
            price = item.original_price.gsub("$","").gsub(",", "").to_f
            item.price = CurrencyRate.convert_to_yen("USD", price)
          end

          images = ""
          # image_node = doc.xpath("//*[@class='main-img']/img/@src")
          # images << image_node.text.strip unless image_node.nil?
          image_list = []
          doc.xpath("//*[@class='product-images media-strip']//a").each do |link|
            unless link['href'].nil?
              image_list << link['href']
            end
          end
          unless image_list.empty?
            images = image_list.join(",")
          end
          item.images = images

          category = url.scan(/(\?tmp=(.)+)/).join('')
          category = category.gsub("?tmp=","")[0..-2]
          item.category_id = LystCategory.by_name(category).category_id
          master_category = MasterCategory.by_category_3_id(item.category_id.to_i)
          if master_category.nil?
            tmp = FashionCrawler::Models::ItemCrawling.new
            tmp.category_id = item.category_id
            tmp.category_name = category
            tmp.brand_id = LystCategory.by_name(category).category_id
            tmp.site_id = 100
            tmp.save!
          else
            item.category_name = master_category.category_3
            if item.category_name.nil?
              item.category_name = master_category.category_2
            end
            general_category_id = master_category.general_category_id
          end

          country_node = doc.at_xpath("//*[@id='product-content']//*[@class='retailer-name']")
          unless country_node.nil?
            country = country_node.text.strip
            country = MasterSize.get_country(country)
            item.country_name = country.blank? ? "US" : country
          end

          sizes_node = doc.at_xpath("//*[@id='product-content']//*[@class='retailer-sizes']")
          item.original_size = sizes = MasterSize.standardize_size(sizes_node.text.strip.gsub(/\n|\s|\t/,"").gsub("Availablein","")) unless sizes_node.nil?
          unless sizes.nil?
            if general_category_id.nil?
              item.size = sizes
            else
              final_sizes = []
              sizes.split(",").each do |size|
                unless item.country_name.nil?
                  converted_size = MasterSize.convert_size(sizes,item.country_name,general_category_id)
                end
                if converted_size.nil?
                  item.size = sizes
                  next
                else
                  final_sizes << converted_size.convert_size
                end
              end
              unless final_sizes.empty?
                item.size = "JP " + final_sizes.join(",")
              end
            end
          end

          item.added_or_updated = true

          stock = doc.at_xpath("//span[@class='buy button']")
          if stock.present?
            item.flag = 1
          else
            item.flag = 0
          end

          if !item.name.blank? && !item.brand_name.blank? && !item.price.blank? && item.flag == 1
            item.save!
          end
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
