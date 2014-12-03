# encoding: utf-8
require 'nokogiri'
require 'unicode'
require 'uri'
require 'date'

module FashionCrawler
  module Tasks
    class ShopStyleCanadaProcessAtMainPage
     def self.execute(url, body)
      doc = Nokogiri::HTML(body)
      begin
        puts NBSP
        doc.xpath("//a").each do |link|
          if !link['href'].nil? && link['href'].match(/Categories\?catId=/) && !link['href'].include?("living")
            category1 = link.text.strip
            url_cate1 = "http://www.shopstyle.ca#{link['href']}"
            unless FashionCrawler::Models::Resource.where(url: url_cate1).exists?
              FashionCrawler::Models::Resource.create({
                url: url_cate1,
                task: 'ShopStyleCanadaProcessAtCate1Page',
                is_visited: false,
                site_name: 'ShopStyleCanada',
                store: FashionCrawler::Models::Store.find_by(name: 'ShopStyleCanada')
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

    class ShopStyleCanadaProcessAtCate1Page
      def self.execute(url, body)
        doc = Nokogiri::HTML(body)
        begin

          doc.xpath("//*[@ng-repeat='data in data.children']//a").each do |link|
            path = link.path.gsub("/a", "")
            if doc.at_xpath("#{path}/ul/li").blank? && link['href'].match(/browse\//) && !NOCRAWLINKS.include?(link['href'].gsub("/browse/", ""))
              url_cate2 = "http://www.shopstyle.ca#{link['href']}"
              unless FashionCrawler::Models::Resource.where(url: url_cate2).exists?
                FashionCrawler::Models::Resource.create({
                  url: url_cate2,
                  task: 'ShopStyleCanadaProcessAtCate2Page',
                  is_visited: false,
                  site_name: 'ShopStyleCanada',
                  store: FashionCrawler::Models::Store.find_by(name: 'ShopStyleCanada')
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

    class ShopStyleCanadaProcessAtCate2Page
      def self.execute(url, body)
        doc = Nokogiri::HTML(body)
        begin

          category = url.gsub("http://www.shopstyle.ca/browse/", "").gsub(/\?page(.)*/,"")

          doc.xpath("//a").each do |link|
            if !link['href'].nil? && link['href'].match(/p\/(.)*\/[\d]+/)
              url_detail = "http://www.shopstyle.ca#{link['href']}?tmp=#{category}"
              unless FashionCrawler::Models::Resource.where(url: url_detail).exists?
                FashionCrawler::Models::Resource.create({
                  url: url_detail,
                  task: 'ShopStyleCanadaProcessAtDetailPage',
                  is_visited: false,
                  site_name: 'ShopStyleCanada',
                  store: FashionCrawler::Models::Store.find_by(name: 'ShopStyleCanada')
                  })
              end
            end
            if !link['href'].nil? && link['href'].match(/pageNumber=/)
              url_paging = "http://www.shopstyle.ca#{link['href']}"
              unless FashionCrawler::Models::Resource.where(url: url_paging).exists?
                FashionCrawler::Models::Resource.create({
                  url: url_paging,
                  task: 'ShopStyleCanadaProcessAtCate2Page',
                  is_visited: false,
                  site_name: 'ShopStyleCanada',
                  store: FashionCrawler::Models::Store.find_by(name: 'ShopStyleCanada')
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

    class ShopStyleCanadaProcessAtDetailPage
      def self.execute(url, body)
        doc = Nokogiri::HTML(body)
        begin
          url2 = url.gsub(/\?tmp=(.)*/, "")
          product = FashionCrawler::Models::Item.where(link: url2).first
          if product.nil?
            item = FashionCrawler::Models::Item.new
            item.link = url2

            name = doc.at_xpath("//*[@itemprop='name']")
            item.name = name.text.strip unless name.nil?

            master_brand = MasterBrand.by_brand_name_include(" " + item.name)
            brand = ""
            if master_brand.nil?
              brand_node = doc.at_xpath("//*[@itemprop='breadcrumb']/a[3]/@href")
              brand = brand_node.text.strip.gsub(/(.)*\//, "").gsub("-", " ") unless brand_node.nil?
              master_brand = MasterBrand.by_brand_name(brand)
            end
            unless master_brand.nil?
              item.brand_id = master_brand.brand_id
              item.brand_name = item.brand_id == 100000 ? brand : master_brand.brand_name
              item.brand_name_ja = master_brand.brand_name_ja.nil? ? "" : master_brand.brand_name_ja

              item.country_name  = "Canada"
              item.site_id = 6
              item.site_name = "SHOPSTYLE Canada"

              images = ""
              image_nodes = doc.xpath("//*[@class='altImageSmall']//img")
              image_nodes.each_with_index do |img_node, i|
                unless img_node['src'].nil?
                  if i == image_nodes.size - 1
                    images << "#{img_node['src']},#{img_node['src'].gsub(/smallmed\.jpg/,"best.jpg")}"
                  else
                    images << "#{img_node['src']},#{img_node['src'].gsub(/smallmed\.jpg/,"best.jpg")},"
                  end
                end
              end
              if images.blank?
                image_nodes = doc.at_xpath("//*[@itemprop='image']/@src")
                item.images = image_nodes.text.strip unless image_nodes.nil?
              else
                item.images = images
              end
            end
          else
            item = product
          end

          color_nodes = doc.xpath("//*[@ng-repeat='color in product.colors']")
          unless color_nodes.nil?
            colors = []
            color_nodes.each_with_index do |node, i|
              colors << node.text.strip
            end
            item.colors = colors.join(",")
          end

          description = doc.at_xpath("//*[@itemprop='description']")
          item.description = description.text.strip unless description.nil?

          original_price = doc.at_xpath("//*[@class='productPrice']//*[@class='originalPrice']")
          unless original_price.nil?
            item.original_base_price = original_price.text.strip
            item.base_price = CurrencyRate.convert_price_to_yen("CAD", item.original_base_price, "$")
          end

          price = doc.at_xpath("//*[@itemprop='price']")
          unless price.nil?
            item.original_price = price.text.strip
            item.price = CurrencyRate.convert_price_to_yen("CAD", item.original_price, "$")
          end

          category = url.scan(/(\?tmp=(.)+)/).join('')
          category = category.gsub("?tmp=","")[0..-2]
          item.category_id = ShopstyleCategory.by_name(category).category_id
          master_category = MasterCategory.by_category_3_id(item.category_id.to_i)
          unless master_category.nil?
            item.category_name = master_category.category_3
            if item.category_name.nil?
              item.category_name = master_category.category_2
            end
            general_category_id = master_category.general_category_id
          end

          sizes_nodes = doc.xpath("//*[@ng-repeat='size in product.sizes']")
          sizes = []
          unless sizes_nodes.nil?
            sizes_nodes.each do |node|
              sizes << node.text.strip
            end
            sizes = sizes.join(",")
            item.original_size = sizes = MasterSize.standardize_size(sizes)
            if general_category_id.nil?
              item.size = item.original_size
            else
              item.size = MasterSize.convert_sizes(item.original_size, "US", general_category_id)
            end
          end

          item.added_or_updated = true

          ## check product have in stock with convention: 1 have in stock, 0 haven't in stock
          check_stock = doc.xpath("//span[@class='priceLabel soldOut']")
          if check_stock.present?
            item.flag = 0
            puts "Have in stock: #{item.flag} with links #{url2}"
          else
            item.flag = 1
          end

          if !item.name.blank? && !item.brand_name.blank? && !item.price.blank? && item.flag == 1
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
