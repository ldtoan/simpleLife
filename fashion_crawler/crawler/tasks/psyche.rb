# encoding: utf-8
require 'nokogiri'
require 'unicode'
require 'uri'
require 'date'
require 'open-uri'

module FashionCrawler
  module Tasks
    class PsycheProcessAtMainPage
      def self.execute(url, body)
        begin
          list_cate = ["http://psyche.co.uk/womens/jumpsuits#,p:1,c:Dresses",
                      "http://psyche.co.uk/womens/jumpsuits#,p:1,c:Jumpsuit",
                      "http://psyche.co.uk/womens/dresses",
                      "http://psyche.co.uk/womens/accessories#,p:1,c:Accessories",
                      "http://psyche.co.uk/womens/accessories#,p:1,c:Jewellery",
                      "http://psyche.co.uk/womens/accessories#,p:1,c:Socks",
                      "http://psyche.co.uk/womens/accessories#,p:1,c:Sunglasses",
                      "http://psyche.co.uk/womens/accessories#,p:1,c:Watches",
                      "http://psyche.co.uk/womens/bags-purses",
                      "http://psyche.co.uk/womens/fragrance",
                      "http://psyche.co.uk/womens/footwear",
                      "http://psyche.co.uk/womens/jeans",
                      "http://psyche.co.uk/womens/shorts",
                      "http://psyche.co.uk/womens/jackets-outerwear",
                      "http://psyche.co.uk/womens/knitwear",
                      "http://psyche.co.uk/womens/skirts",
                      "http://psyche.co.uk/womens/jewellery",
                      "http://psyche.co.uk/womens/swimwear",
                      "http://psyche.co.uk/womens/tops#,p:1,c:Polo Shirts",
                      "http://psyche.co.uk/womens/tops#,p:1,c:Shirts",
                      "http://psyche.co.uk/womens/tops#,p:1,c:Sweatshirts",
                      "http://psyche.co.uk/womens/tops#,p:1,c:T-shirts",
                      "http://psyche.co.uk/womens/tops#,p:1,c:Tops & Hoodies",
                      "http://psyche.co.uk/womens/watches",
                      "http://psyche.co.uk/womens/trousers",
                      "http://psyche.co.uk/mens/footwear",
                      "http://psyche.co.uk/mens/fragrance",
                      "http://psyche.co.uk/mens/jackets-and-outerwear",
                      "http://psyche.co.uk/mens/jeans",
                      "http://psyche.co.uk/mens/casual-shirts",
                      "http://psyche.co.uk/mens/polo-shirts",
                      "http://psyche.co.uk/mens/formal-shirts",
                      "http://psyche.co.uk/mens/shorts#,p:1,c:Shorts",
                      "http://psyche.co.uk/mens/shorts#,p:1,c:Swimwear",
                      "http://psyche.co.uk/mens/sunglasses",
                      "http://psyche.co.uk/mens/suits",
                      "http://psyche.co.uk/mens/sweatshirts#,p:1,c:Jackets & Outerwear",
                      "http://psyche.co.uk/mens/sweatshirts#,p:1,c:Sweatshirts",
                      "http://psyche.co.uk/mens/swimwear",
                      "http://psyche.co.uk/mens/trousers",
                      "http://psyche.co.uk/mens/t-shirts",
                      "http://psyche.co.uk/mens/waistcoats#,p:1,c:Suits",
                      "http://psyche.co.uk/mens/watches",
                      "http://psyche.co.uk/kids/accessories#,p:1,c:Accessories",
                      "http://psyche.co.uk/kids/accessories#,p:1,c:Socks",
                      "http://psyche.co.uk/kids/coats-jackets",
                      "http://psyche.co.uk/kids/dresses",
                      "http://psyche.co.uk/kids/footwear",
                      "http://psyche.co.uk/kids/jeans",
                      "http://psyche.co.uk/kids/shorts",
                      "http://psyche.co.uk/kids/tops#,p:1,c:Jackets & Outerwear",
                      "http://psyche.co.uk/kids/tops#,p:1,c:Polo Shirts",
                      "http://psyche.co.uk/kids/tops#,p:1,c:T-shirts",
                      "http://psyche.co.uk/kids/trousers"]
          list_cate.each do |link|
            FashionCrawler::Models::Resource.create({
              url: link.to_s,
              task: 'PsycheProcessAtCatePage',
              is_visited: false,
              site_name: 'Psyche',
              store: FashionCrawler::Models::Store.find_by(name: 'Psyche')
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


    class PsycheProcessAtCatePage
      def self.execute(url, body)
        doc = Nokogiri::HTML(body)
        begin
          parse_paging = doc.xpath("//ul[@class='paging']//li")
          parse_paging = parse_paging[parse_paging.count - 1].try(:text) if parse_paging.present?
          parse_paging = parse_paging.downcase.gsub("showing page 1 of ","").try(:to_i) if parse_paging.present?
          if parse_paging.present? && parse_paging.kind_of?(Integer)
            for i in 1..parse_paging
              if url.include?("p:1")
                detail_url = url.gsub("p:1", "p:#{i}")
              else
                detail_url = url + "?p=#{i}"
              end
              FashionCrawler::Models::Resource.create({
                url: detail_url,
                task: 'PsycheProcessAtListDetailPage',
                is_visited: false,
                site_name: 'Psyche',
                store: FashionCrawler::Models::Store.find_by(name: 'Psyche')
              })
            end
          else
            FashionCrawler::Models::Resource.create({
              url: url,
              task: 'PsycheProcessAtListDetailPage',
              is_visited: false,
              site_name: 'Psyche',
              store: FashionCrawler::Models::Store.find_by(name: 'Psyche')
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

    class PsycheProcessAtListDetailPage
      def self.execute(url, body)
        base_url = "http://psyche.co.uk"
        doc = Nokogiri::HTML(body)
        begin
          parse_list = doc.xpath("//div[@id='products-listing']//@href")
          if parse_list.present?
            parse_list.each do |link|
              detail_url = base_url + link.try(:value)
              unless FashionCrawler::Models::Resource.where(url: detail_url).exists?
                FashionCrawler::Models::Resource.create({
                  url: detail_url,
                  task: 'PsycheProcessAtDetailPage',
                  is_visited: false,
                  site_name: 'Psyche',
                  category_name_url: url,
                  store: FashionCrawler::Models::Store.find_by(name: 'Psyche')
                })
              end
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

    class PsycheProcessAtDetailPage
      def self.execute(url, body)
        doc = Nokogiri::HTML(body)
        category_name = FashionCrawler::Models::Resource.find_by(url: url).try(:category_name_url)
        begin
          product = FashionCrawler::Models::Item.where(link: url).first
          if product.nil?
            item = FashionCrawler::Models::Item.new
            item.link = url
            brand_node = doc.at_xpath("//div[@class='description-block']//strong[@itemprop='brand']").try(:children).try(:text)
            brand_node = doc.at_xpath("//div[@class='description-block']//img").try(:attributes)["title"].try(:value) unless brand_node.present?

            brand_name = brand_node.strip if brand_node.present?

            name = doc.at_xpath("//div[@class='description-block']//span[@itemprop='name']").try(:children).try(:text)
            item.name = name.strip unless name.nil?

            unless brand_name.nil?
              master_brand = MasterBrand.by_brand_name(brand_name)
              unless master_brand.nil?
                item.brand_id = master_brand.brand_id
                item.brand_name = MasterBrand.id_is_other?(item.brand_id) ? brand_name : master_brand.brand_name
                item.brand_name_ja = master_brand.brand_name_ja
              end
            end

            item.site_id = 21
            item.site_name = "Psyche"
          else
            item = product
          end

          parse_description = doc.at_xpath("//div[@class='accordion description-tabs']//div[@class='open-close active']//a[@class='open-link']")
          if parse_description.present?
            title_description = parse_description.try(:children).try(:text)
            if title_description.present? && title_description.try(:downcase).include?("stylist")
              detail_description = doc.at_xpath("//div[@class='accordion description-tabs']//div[@class='open-close active']//div[@class='slider']").try(:text)
              description = detail_description.gsub(/\r|\n|\t|  |\"/,"").try(:strip) if detail_description.present?
              description = description.split("Product Code:").try(:first).try(:strip) if description.include?("Product Code")
              item.description = description if description.present?
            end
          end

          original_price = doc.at_xpath("//div[@class='description-block']//div[@class='price-box']/strong[@class='price']").try(:text).try(:strip)

          if original_price.present?
            item.original_price = original_price
          end

          images = []
          doc.xpath("//ul[@id='thumbnail_carousel']//@src").each do |img|
            img_src = img.try(:value) if img.present?
            images << img_src.gsub(/\/[0-9]+\/[0-9]+/,"/1000/1000") if img_src.present?
          end
          item.images = images.join(",")

          item.category_id = PsycheCategory.by_split_name(category_name).try(:category_id)
          master_category = MasterCategory.by_category_3_id(item.category_id)
          unless master_category.nil?
            item.category_name = master_category.category_3
            general_category_id = master_category.general_category_id
          end

          sizes = []
          number_of_products = 0
          parse_size = doc.xpath("//div[@class='sel-item']/select[@class='property size_selector']//option")
          if parse_size.present?
            parse_size.each do |option|
              get_size = option.try(:children).try(:text).try(:strip).try(:downcase)
              if get_size.present? && !get_size.include?("select")
                sizes << get_size
                number_of_products = number_of_products + 3
              end
            end
            sizes = sizes.join(',')
          end

          unless sizes.empty?
            item.original_size = sizes
            if general_category_id.nil?
              item.size = item.original_size
            else
              item.size = MasterSize.convert_sizes(item.original_size, "US", general_category_id)
            end
          end


          if number_of_products > 0
            item.flag = 1
            item.number_of_products = number_of_products
          end

          if item.name.present? && item.try(:category_name).present? && item.flag == 1
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
