# encoding: utf-8
require 'nokogiri'
require 'unicode'
require 'uri'
require 'date'
require 'open-uri'

module FashionCrawler
  module Tasks
    class YooxProcessAtMainPage
      def self.execute(url, body)
        begin
          list_cate = ["http://www.yoox.com/us/categoryindex?dept=women",
                      "http://www.yoox.com/us/categoryindex?dept=men"]
          list_cate.each do |link|
            detail_url = link.include?(" ") ? link.gsub(/ /,"%20") : link
            FashionCrawler::Models::Resource.create({
              url: detail_url,
              task: 'YooxProcessAtListCategoryPage',
              is_visited: false,
              site_name: 'Yoox',
              store: FashionCrawler::Models::Store.find_by(name: 'Yoox')
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

    class YooxProcessAtListCategoryPage
      def self.execute(url, body)
        doc = Nokogiri::HTML(body)
        base_url = "http://www.yoox.com"
        parse_parent_cat = doc.xpath("//ul[@class='macroList']/li[@class='macro fontBold']")
        parse_children_cat = doc.xpath("//ul[@class='macroList']/li[@class='microBlock']")

        arr_parent = []
        arr_child = []
        if parse_parent_cat.present?
          parse_parent_cat.each do |parent|
            arr_parent << parent.try(:text).try(:strip)
          end
        end

        hash_result_cat = {}.compare_by_identity
        if parse_children_cat.present?
          parse_children_cat.each_with_index do |children_cat, index|
            hash_cat_url = {}.compare_by_identity
            arr_list_cats = []
            children_cat.children.each do |node_children|
              if node_children.try(:children).present?
                node_children.children.each do |parse_node_children|
                  parse_node_children.children.each do |node_result|
                    if node_result.try(:attributes).present?
                      hash_child_cat = {}.compare_by_identity
                      hash_child_cat[:name] = node_result.attributes["title"].try(:value).try(:strip)
                      hash_child_cat[:url]  = base_url + node_result.attributes["href"].try(:value).try(:strip)
                      arr_list_cats << hash_child_cat
                    end
                  end
                end
              end
            end
            hash_cat_url[:name] = arr_parent[index]
            hash_cat_url[:cats] = arr_list_cats
            hash_result_cat[:"#{index}"] = hash_cat_url
          end
        end

        begin
          hash_result_cat.each do |key, value|
            value[:cats].each do |link|
              detail_url = link[:url].include?(" ") ? link[:url].gsub(/ /,"%20") : link[:url]
              unless FashionCrawler::Models::Resource.where(url: detail_url).exists?
                FashionCrawler::Models::Resource.create({
                  url: detail_url,
                  task: 'YooxProcessAtCatePage',
                  is_visited: false,
                  site_name: 'Yoox',
                  category_name_url: link[:name],
                  store: FashionCrawler::Models::Store.find_by(name: 'Yoox')
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

    class YooxProcessAtCatePage
      def self.execute(url, body)
        doc = Nokogiri::HTML(body)
        category_name = FashionCrawler::Models::Resource.find_by(url: url).try(:category_name_url)
        begin
          parse_paging = doc.at_xpath("//div[@class='pagination floatRight']//li[@class='lastPage']").try(:text).try(:strip).try(:to_i)
          list_paging = doc.at_xpath("//div[@class='pagination floatRight']//li[@class='lastPage']//@href")
          list_paging = doc.at_xpath("//div[@class='pagination floatRight']//li[@class='firstPage']//@href") unless list_paging.present?

          if parse_paging.present? && parse_paging.try(:to_i) == 1 && !list_paging.present?
            # detail_url = URI.encode(url)
            detail_url = url.include?(" ") ? url.gsub(/ /,"%20") : url
            FashionCrawler::Models::Resource.create({
              url: detail_url,
              task: 'YooxProcessAtListDetailPage',
              is_visited: false,
              site_name: 'Yoox',
              category_name_url: category_name,
              store: FashionCrawler::Models::Store.find_by(name: 'Yoox')
            })
          elsif list_paging.present? && parse_paging.present? && parse_paging.try(:to_i) != 0
            for i in 1..parse_paging.try(:to_i)
              detail_url = list_paging.try(:value).gsub(/\&page\=\d+/,"&page=#{i}")
              detail_url = detail_url.include?(" ") ? detail_url.gsub(/ /,"%20") : detail_url
              FashionCrawler::Models::Resource.create({
                url: detail_url,
                task: 'YooxProcessAtListDetailPage',
                is_visited: false,
                site_name: 'Yoox',
                category_name_url: category_name,
                store: FashionCrawler::Models::Store.find_by(name: 'Yoox')
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

    class YooxProcessAtListDetailPage
      def self.execute(url, body)
        doc = Nokogiri::HTML(body)
        base_url = "http://www.yoox.com"
        category_name = FashionCrawler::Models::Resource.find_by(url: url).try(:category_name_url)
        begin
          parse_list = doc.xpath("//div[@id='itemsGrid']//div[@class='itemImg']")
          if parse_list.present?
            parse_list.each do |list_products|
              if list_products.try(:children).present?
                if list_products.try(:children)[1].try(:attributes)["href"].try(:value).present?
                  detail_url = base_url + list_products.try(:children)[1].try(:attributes)["href"].try(:value)
                  detail_url = detail_url.include?(" ") ? detail_url.gsub(/ /,"%20") : detail_url
                  unless FashionCrawler::Models::Resource.where(url: detail_url).exists?
                    FashionCrawler::Models::Resource.create({
                      url: detail_url,
                      task: 'YooxProcessAtDetailPage',
                      is_visited: false,
                      site_name: 'Yoox',
                      category_name_url: category_name,
                      store: FashionCrawler::Models::Store.find_by(name: 'Yoox')
                    })
                  end
                end
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

    class YooxProcessAtDetailPage
      def self.execute(url, body)
        doc = Nokogiri::HTML(body)
        category_name = FashionCrawler::Models::Resource.find_by(url: url).try(:category_name_url)
        begin
          product = FashionCrawler::Models::Item.where(link: url).first
          if product.nil?
            item = FashionCrawler::Models::Item.new
            item.link = url
            brand_node = doc.at_xpath("//div[@id='itemTitle']/h2//span")
            brand_name =  brand_node.try(:children).try(:text).try(:capitalize).try(:strip) if brand_node.present?

            name = doc.at_xpath("//div[@id='itemTitle']/h1//span").try(:children).try(:text).try(:strip)
            item.name = name if name.present?

            unless brand_name.nil?
              master_brand = MasterBrand.by_brand_name(brand_name)
              unless master_brand.nil?
                item.brand_id = master_brand.brand_id
                item.brand_name = MasterBrand.id_is_other?(item.brand_id) ? brand_name : master_brand.brand_name
                item.brand_name_ja = master_brand.brand_name_ja
              end
            end

            item.site_id = 26
            item.site_name = "Yoox"
          else
            item = product
          end


          parse_description = doc.at_xpath("//div[@id='itemInfoTab']/div[@id='tabs-1']").try(:text).try(:strip)
          if parse_description.present?
            description = parse_description.gsub(/\r\n|  /,"")
            description = description.split("Product code:").try(:first).try(:strip) if description.include?("Product code")
            item.description = description if description.present?
          end

          original_price = doc.xpath("//div[@id='itemPrice']//span[@itemprop='price']").try(:text).try(:strip)
          if original_price.present?
            item.original_price = original_price.gsub(/ /,"")
          end

          original_base_price = doc.xpath("//div[@id='itemPrice']/div[@class='oldprice']").try(:text).try(:strip)
          if original_base_price.present?
            item.original_base_price = original_base_price.gsub(/ /,"")
          end

          images = []
          side_images = doc.xpath("//div[@id='itemImage']//div[@id='openZoom']//@src")
          main_images = doc.xpath("//div[@id='itemImage']//ul[@id='itemThumbs']//@src")

          if main_images.present?
            main_images.each do |image|
              images << image.try(:value).gsub(/\_\d\_/,"_#{12}_")
            end
          else
            images << side_images.try(:value) if side_images.present?
          end
          item.images = images.join(",")

          category_parents = url.scan(/dept=[wo]*men/).join("").split("dept=").try(:last)
          category_name_url = "#{category_name},#{category_parents}" if category_name.present? && category_parents.present?
          if category_name_url.present?
            item.category_id = YooxCategory.by_split_name(category_name_url).try(:category_id)
            master_category = MasterCategory.by_category_3_id(item.category_id)
            unless master_category.nil?
              item.category_name = master_category.category_3
              general_category_id = master_category.general_category_id
            end
          end
          colors = []
          parse_color = doc.xpath("//ul[@class='colorsizelist']//img")
          if parse_color.present?
            parse_color.each do |color|
              get_color = color.try(:attributes)["alt"].try(:value).try(:strip)
              colors << Color.crawler_extract_color_name(get_color)
            end
          end

          colors_temp = colors.join(",")
          if colors_temp.present? && colors_temp.include?(",")
            begin
              color_temp = colors_temp.split(",").reject! {|c| c.empty?}
              colors_temp = color_temp.present? ? color_temp.join(",") : colors_temp.split(",").join(",")
            rescue => e
            end
          end
          puts "######################################"
          puts "#{colors_temp}"
          puts "######################################"
          item.colors = colors_temp if colors_temp.present?

          sizes = ""
          parse_size = doc.xpath("//ul[@class='colorsizelist']")
          if parse_size.present?
            parse_sizes = parse_size[1].try(:text).try(:strip)
            sizes = parse_sizes.gsub(/\r\n/,",").gsub(/ /,"") if parse_sizes.present?
          end

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
