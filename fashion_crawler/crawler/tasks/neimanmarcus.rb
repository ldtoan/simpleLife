# encoding: utf-8
require 'nokogiri'
require 'unicode'
require 'uri'
require 'date'
require 'open-uri'

module FashionCrawler
  module Tasks
    class NeimanMarcusProcessAtMainPage
      def self.execute(url, body)
        begin
          list_cate = NeimanMarcusCategory.try(:all)
          list_cate.each do |link|
            FashionCrawler::Models::Resource.create({
              url: link.try(:id),
              task: 'NeimanMarcusProcessAtListCategoryPage',
              is_visited: false,
              site_name: 'NeimanMarcus',
              store: FashionCrawler::Models::Store.find_by(name: 'NeimanMarcus')
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

    class NeimanMarcusProcessAtListCategoryPage
      def self.execute(url, body)
        doc = Nokogiri::HTML(body)
        obj_neimanmarcus = NeimanMarcusProcessAtListCategoryPage.new
        number_paging = obj_neimanmarcus.get_number_paging(doc, url)
        begin
          if number_paging.zero?
            obj_neimanmarcus.process_paging(url, url)
          else
            for i in 1..number_paging
              detail_url = obj_neimanmarcus.link_paging(url,i)
              obj_neimanmarcus.process_paging(detail_url, url)
            end
          end
        rescue => e
          puts e.inspect
          puts e.backtrace
        ensure
          FashionCrawler::Models::Resource.where(url: url).update_all(is_visited: true)
        end
      end

      def process_paging(detail_url, url)
        FashionCrawler::Models::Resource.create({
          url: detail_url,
          task: 'NeimanMarcusProcessAtCatePage',
          is_visited: false,
          site_name: 'NeimanMarcus',
          store: FashionCrawler::Models::Store.find_by(name: 'NeimanMarcus'),
          category_name_url: url
        })
      end

      def get_number_paging(doc, url)
        parse_paging = doc.xpath("//ul[@class='epaging pagination']")[0]
        parse_paging = parse_paging.present? ? parse_paging.try(:children) : nil
        parse_paging = parse_paging.present? ? parse_paging[parse_paging.try(:count).try(:to_i) - 4].try(:text).try(:to_i) : 0
      end

      def link_paging(url, page)
        "#{url}#userConstrainedResults=true&page=#{page}&pageSize=30&sort=PCS_SORT&rwd=true"
      end
    end

    class NeimanMarcusProcessAtCatePage
      def self.execute(url, body)
        doc = Nokogiri::HTML(body)
        base_url = "http://www.neimanmarcus.com"
        category_name = FashionCrawler::Models::Resource.find_by(url: url).try(:category_name_url)
        obj_neimanmarcus = NeimanMarcusProcessAtCatePage.new
        list_products = obj_neimanmarcus.instance_eval { list_items(doc, url) }
        begin
          if list_products.present?
            list_products.each do |link|
              detail_url = "#{base_url}#{link.try(:value)}"
              unless FashionCrawler::Models::Resource.where(url: detail_url).exists?
                FashionCrawler::Models::Resource.create({
                  url: detail_url,
                  task: 'NeimanMarcusProcessAtDetailPage',
                  is_visited: false,
                  site_name: 'NeimanMarcus',
                  store: FashionCrawler::Models::Store.find_by(name: 'NeimanMarcus'),
                  category_name_url: url
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

      private
      def list_items(doc, url)
        parse_list_items = doc.xpath("//ul[@class='category-items']//div[@class='productdesigner']//@href")
      end
    end

    class NeimanMarcusProcessAtDetailPage
      def self.price(doc, body)
        parse_price = doc.at_xpath("//p[@class='product-price']").try(:text).try(:strip)
        parse_price = parse_price.present? ? parse_price : nil
      end

      def self.colors(name)
        colors = Color.crawler_extract_color_name(name)
      end

      def self.check_stock(name)
        status = name.present? ? name.try(:downcase).include?("stock") : nil
      end


      def self.match_size(name)
        check = name =~ /(.*)small(.*)/
        check = name =~ /(.*)medium(.*)/ if check.nil?
        check = name =~ /(.*)large(.*)/ if check.nil?
        check
      end

      def self.check_size(name)
        name = name.try(:downcase)
        check_size1 = name.match(/\d/)
        check_size2 = name.include?("size")
        check = NeimanMarcusProcessAtDetailPage.match_size(name)
        size = (check_size1.present? || check_size2.present? || check.try(:zero?)) ? true : nil
      end

      def self.sizes(doc, body)
        sizes = []
        body.scan(/new product(.*);/).each do |size|
          parse_size = size.join("")
          check_color = NeimanMarcusProcessAtDetailPage.colors(parse_size.split(",")[3].gsub(/\'/,""))
          if check_color.empty?
            check_size = NeimanMarcusProcessAtDetailPage.check_size(parse_size.split(",")[3].gsub(/\'/,""))
            status_stock = NeimanMarcusProcessAtDetailPage.check_stock(parse_size)
            sizes << size.join("").split(",")[3].gsub(/\'/,"").try(:strip) if status_stock.present? && check_size.present?
          end
        end
        sizes
      end

      def self.images(doc)
        main_images = doc.xpath("//ul[@class='list-inline']//@src")
        side_images = doc.at_xpath("//div[@class='img-wrap slick-slide']//img")
        side_images = doc.xpath("//div[@class='product-images']//div[@class='img-wrap']//@src")[0] unless side_images.present?

        images = []
        if main_images.present?
          main_images.each do |img|
            images << img.try(:value).gsub("g.jpg","k.jpg")
          end
        else
          images << side_images.try(:value)
        end
        images = images.join(",")
      end

      def self.execute(url, body)
        doc = Nokogiri::HTML(body)
        category_name = FashionCrawler::Models::Resource.find_by(url: url).try(:category_name_url)
        begin
          product = FashionCrawler::Models::Item.where(link: url).first
          if product.nil?
            item = FashionCrawler::Models::Item.new
            item.link = url
            brand_node = doc.at_xpath("//span[@class='product-designer']").try(:text).try(:strip)
            brand_name =  brand_node if brand_node.present?

            name = doc.at_xpath("//h6[@class='product-name']").try(:text).try(:strip)
            name = doc.at_xpath("//h6[@class='hide-on-mobile product-name']").try(:text).try(:strip) unless name.present?
            item.name = name.gsub(/\t|\r|\n/,"").gsub(brand_name,"") if name.present?

            unless brand_name.nil?
              master_brand = MasterBrand.by_brand_name(brand_name)
              unless master_brand.nil?
                item.brand_id = master_brand.brand_id
                item.brand_name = MasterBrand.id_is_other?(item.brand_id) ? brand_name : master_brand.brand_name
                item.brand_name_ja = master_brand.brand_name_ja
              end
            end

            item.site_id = 32
            item.site_name = "NeimanMarcus"
          else
            item = product
          end

          list_images = NeimanMarcusProcessAtDetailPage.images(doc)
          item.images = list_images.present? ? list_images : nil

          category_name_url = category_name
          if category_name_url.present?
            item.category_id = NeimanMarcusCategory.by_name_include(category_name_url).try(:category_id)
            master_category = MasterCategory.by_category_3_id(item.category_id)
            unless master_category.nil?
              item.category_name = master_category.category_3
              general_category_id = master_category.general_category_id
            end
          end

          sizes = []
          status_stock = ""
          body.scan(/new product(.*);/).each do |size|
            parse_size = size.join("")
            check_color = NeimanMarcusProcessAtDetailPage.colors(parse_size.split(",")[3].gsub(/\'/,""))
            if check_color.empty?
              check_size = NeimanMarcusProcessAtDetailPage.check_size(parse_size.split(",")[3].gsub(/\'/,""))
              status_stock = NeimanMarcusProcessAtDetailPage.check_stock(parse_size)
              sizes << size.join("").split(",")[3].gsub(/\'/,"").try(:strip) if status_stock.present? && check_size.present?
            end
          end
          sizes = sizes.try(:uniq)
          unless sizes.empty?
            sizes = sizes.join(",")
            item.original_size = sizes
            if general_category_id.nil?
              item.size = item.original_size
            else
              item.size = MasterSize.convert_sizes(item.original_size, "US", general_category_id)
            end
          end

          parse_description = doc.at_xpath("//div[@class='product-details-info']").try(:text).try(:strip)
          if parse_description.present?
            description = parse_description.gsub(/\r\n/,"")
            if description.try(:downcase).include?("guide")
              description = description.split(".").delete_if {|i| i.include?("Guide")}.join(". ")
            end
            item.description = description if description.present?
          end

          original_price = NeimanMarcusProcessAtDetailPage.price(doc, body)
          if original_price.present?
            item.original_price = original_price.gsub(/[a-zA-Z|\r|\t|\n| ]/,"")
          end

          if item.original_price.present?
            if item.size.present?
              item.flag = 1
              number_of_products = item.size.split(",").try(:count)
              item.number_of_products = number_of_products * 3
            else
              item.flag = status_stock.present? ? 1 : nil
            end
          end

          parse_offers = doc.xpath("//div[@itemprop='offers']").try(:count)
          if item.name.present? && item.try(:category_name).present? && item.flag == 1 && parse_offers == 1
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
