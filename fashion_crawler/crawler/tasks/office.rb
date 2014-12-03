# encoding: utf-8
require 'nokogiri'
require 'unicode'
require 'uri'
require 'date'
require 'open-uri'

module FashionCrawler
  module Tasks
    class OfficeProcessAtMainPage
      def self.execute(url, body)
        begin
          list_cate = OfficeCategory.all
          list_cate.each do |link|
            detail_url = link.id
            category_name = link.data[1]
            FashionCrawler::Models::Resource.create({
              url: detail_url,
              task: 'OfficeProcessAtListCategoryPage',
              is_visited: false,
              site_name: 'Office',
              category_name_url: detail_url,
              store: FashionCrawler::Models::Store.find_by(name: 'Office')
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

    class OfficeProcessAtListCategoryPage
      def self.execute(url, body)
        doc = Nokogiri::HTML(body)
        category_name = FashionCrawler::Models::Resource.find_by(url: url).try(:category_name_url)
        parse_paging = doc.at_xpath("//a[@class='pagination_total']").try(:text).try(:to_i)
        begin
          if parse_paging.present?
            for i in 1..parse_paging
              if url.present?
                detail_url = url.include?("?") ? url + "&page=#{i}" : url + "?page=#{i}"
                unless FashionCrawler::Models::Resource.where(url: detail_url).exists?
                  FashionCrawler::Models::Resource.create({
                    url: detail_url,
                    task: 'OfficeProcessAtCatePage',
                    is_visited: false,
                    site_name: 'Office',
                    category_name_url: category_name,
                    store: FashionCrawler::Models::Store.find_by(name: 'Office')
                  })
                end
              end
            end
          else
            unless FashionCrawler::Models::Resource.where(url: url).exists?
              FashionCrawler::Models::Resource.create({
                url: url,
                task: 'OfficeProcessAtCatePage',
                is_visited: false,
                site_name: 'Office',
                category_name_url: category_name,
                store: FashionCrawler::Models::Store.find_by(name: 'Office')
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

    class OfficeProcessAtCatePage
      def self.execute(url, body)
        doc = Nokogiri::HTML(body)
        base_url = "http://www.office.co.uk"
        category_name = FashionCrawler::Models::Resource.find_by(url: url).try(:category_name_url)
        begin
          list_products = doc.xpath("//div[@class='productList']//a[@class='displayBlock brand']/@href")
          list_products = doc.xpath("//div[@class='productList']//div[@class='productList_img textCenter']/a[@class='displayBlock brand']/@href") unless list_products.present?

          if list_products.present?
            list_products.each do |link|
              detail_url = "#{base_url}#{link}" if link.present?
              unless FashionCrawler::Models::Resource.where(url: detail_url).exists?
                FashionCrawler::Models::Resource.create({
                  url: detail_url,
                  task: 'OfficeProcessAtListDetailPage',
                  is_visited: false,
                  site_name: 'Office',
                  category_name_url: category_name,
                  store: FashionCrawler::Models::Store.find_by(name: 'Office')
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

    class OfficeProcessAtListDetailPage
      def self.execute(url, body)
        doc = Nokogiri::HTML(body)
        category_name = FashionCrawler::Models::Resource.find_by(url: url).try(:category_name_url)
        begin
          product = FashionCrawler::Models::Item.where(link: url).first
          if product.nil?
            item = FashionCrawler::Models::Item.new
            item.link = url
            brand_node = doc.at_xpath("//div[@class='floatProperties mxWidth']/h1[@class='productBrand bold ']")
            brand_name =  brand_node.try(:children).try(:text).try(:capitalize).try(:strip) if brand_node.present?

            name = doc.at_xpath("//h2[@class='productName darkergrey fArial fTtransformNone']").try(:children).try(:text).try(:strip)
            item.name = name if name.present?

            unless brand_name.nil?
              master_brand = MasterBrand.by_brand_name(brand_name)
              unless master_brand.nil?
                item.brand_id = master_brand.brand_id
                item.brand_name = MasterBrand.id_is_other?(item.brand_id) ? brand_name : master_brand.brand_name
                item.brand_name_ja = master_brand.brand_name_ja
              end
            end

            item.site_id = 28
            item.site_name = "Office"
          else
            item = product
          end

          parse_color = doc.at_xpath("//h2[@class='productColour darkergrey mb10 fArial fTtransformNone']").try(:children).try(:text).try(:strip)
          if parse_color.present?
            item.colors =  Color.crawler_extract_color_name(parse_color.try(:downcase))
          end

          name = doc.at_xpath("//h2[@class='productName darkergrey fArial fTtransformNone']").try(:children).try(:text).try(:strip)
          name = "#{name} #{parse_color}" if parse_color.present?
          item.name = name if name.present?


          parse_description = doc.xpath("//div[@id='productDetail_tab1']//p").try(:text).try(:strip)
          parse_description = doc.xpath("//div[@id='productDetail_tab1']/h3").try(:text).try(:strip) unless parse_description.present?
          if parse_description.present?
            description = parse_description.gsub(/\r\n|  /,"")
            item.description = description if description.present?
          end

          original_price = doc.xpath("//div[@id='now_price']").try(:text).try(:strip)
          if original_price.present?
            item.original_price = original_price.gsub(/[a-zA-Z|\r|\t|\n| ]/,"")
          end

          original_base_price = doc.at_xpath("//div[@id='WAS_price']").try(:text).try(:strip)
          if original_base_price.present?
            item.original_base_price = original_base_price.gsub(/[a-zA-Z|\r|\t|\n| ]/,"")
          end

          images = []
          main_images = doc.xpath("//div[@id='ql_product_thumbnails']//img/@highres")
          side_images = doc.xpath("//div[@class='ql_product_picture floatProperties']/a/img").try(:value) unless main_images.present?
          if main_images.present?
            main_images.each do |image|
              link_image = image.try(:value)
              link_image = "http:" + link_image unless link_image.include?("http")
              images << link_image
            end
          else
            side_images = doc.xpath("//div[@class='ql_product_picture floatProperties ql_product_nothumbnails']/a/img")[0].try(:attributes)["src"].try(:value) unless side_images.present?
            side_image = "http:" + side_images if side_images.present?
            images << side_image if side_image.present?
          end
          item.images = images.join(",")

          category_name_url = category_name
          if category_name_url.present?
            item.category_id = OfficeCategory.by_name_include(category_name_url).try(:category_id)
            master_category = MasterCategory.by_category_3_id(item.category_id)
            unless master_category.nil?
              item.category_name = master_category.category_3
              general_category_id = master_category.general_category_id
            end
          end

          sizes = []
          parse_size = doc.xpath("//ul[@class='productDetail_purchaseOptions']/li[@class='sizeOptions']//option")
          if parse_size.present?
            parse_size.children.each do |size|
              sizes_temp = size.try(:text).try(:strip).try(:downcase)
              sizes << sizes_temp unless sizes_temp.include?("select")
            end
          end
          sizes = sizes.join(",")
          unless sizes.empty?
            item.original_size = sizes
            if general_category_id.nil?
              item.size = item.original_size
            else
              item.size = MasterSize.convert_sizes(item.original_size, "US", general_category_id)
            end
          end

          if item.original_price.present?
            item.flag = 1
            if item.size.present?
              number_of_products = item.size.split(",").try(:count)
              item.number_of_products = 3 * number_of_products
            end
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
