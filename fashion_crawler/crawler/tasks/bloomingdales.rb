# encoding: utf-8
require 'nokogiri'
require 'unicode'
require 'uri'
require 'date'

CATEGORIES_1 = ["WOMEN", "SHOES", "ACCESSORIES", "MEN", "KIDS"]

module FashionCrawler
  module Tasks
    class BloomingdalesProcessAtMainPage
     def self.execute(url, body)
      doc = Nokogiri::HTML(body)
      begin
        doc.xpath("//*[@id='globalNavigation']//a").each do |link|
          if !link['href'].nil?
            match = false
            CATEGORIES_1.each do |category|
              match = true if link['href'].match(category)
            end
            if match == true
              url_1 = "http://www1.bloomingdales.com#{link['href']}"
              FashionCrawler::Models::Resource.create({
                url: url_1,
                task: 'BloomingdalesProcessAtCatePage',
                is_visited: false,
                site_name: 'Bloomingdales',
                store: FashionCrawler::Models::Store.find_by(name: 'Bloomingdales')
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


    class BloomingdalesProcessAtCatePage
      def self.execute(url, body)
        doc = Nokogiri::HTML(body)
        begin
          if url.include?("WOMEN")
            doc.xpath("//*[@id='nav_category']/div[3]//a").each do |link|
              category_url = link['href']
              unless FashionCrawler::Models::Resource.where(url: category_url).exists?
                FashionCrawler::Models::Resource.create({
                  url: category_url,
                  task: 'BloomingdalesProcessAtPagingPage',
                  is_visited: false,
                  site_name: 'Bloomingdales',
                  store: FashionCrawler::Models::Store.find_by(name: 'Bloomingdales')
                  })
              end
            end
          elsif url.include?("MEN")
            doc.xpath("//*[@id='nav_category']/div[2]//a").each do |link|
              category_url = link['href']
              unless FashionCrawler::Models::Resource.where(url: category_url).exists?
                FashionCrawler::Models::Resource.create({
                  url: category_url,
                  task: 'BloomingdalesProcessAtPagingPage',
                  is_visited: false,
                  site_name: 'Bloomingdales',
                  store: FashionCrawler::Models::Store.find_by(name: 'Bloomingdales')
                  })
              end
            end
            doc.xpath("//*[@id='nav_category']/div[3]//a").each do |link|
              if !link['href'].nil? && !link['href'].match("all-shoes")
                category_url = link['href']
                unless FashionCrawler::Models::Resource.where(url: category_url).exists?
                  FashionCrawler::Models::Resource.create({
                    url: category_url,
                    task: 'BloomingdalesProcessAtPagingPage',
                    is_visited: false,
                    site_name: 'Bloomingdales',
                    store: FashionCrawler::Models::Store.find_by(name: 'Bloomingdales')
                    })
                end
              end
            end
            doc.xpath("//*[@id='nav_category']/div[4]//a").each do |link|
              if !link['href'].nil? && !link['href'].match("all-accessories") && !link['href'].match("cologne-grooming")
                category_url = link['href']
                unless FashionCrawler::Models::Resource.where(url: category_url).exists?
                  FashionCrawler::Models::Resource.create({
                    url: category_url,
                    task: 'BloomingdalesProcessAtPagingPage',
                    is_visited: false,
                    site_name: 'Bloomingdales',
                    store: FashionCrawler::Models::Store.find_by(name: 'Bloomingdales')
                    })
                end
              end
            end
          elsif url.include?("ACCESSORIES")
            doc.xpath("//*[@id='nav_category']/div[4]//a").each do |link|
              if !link['href'].nil? && !link['href'].match("charms")
                category_url = link['href']
                unless FashionCrawler::Models::Resource.where(url: category_url).exists?
                  FashionCrawler::Models::Resource.create({
                    url: category_url,
                    task: 'BloomingdalesProcessAtPagingPage',
                    is_visited: false,
                    site_name: 'Bloomingdales',
                    store: FashionCrawler::Models::Store.find_by(name: 'Bloomingdales')
                    })
                end
              end
            end
            doc.xpath("//*[@id='nav_category']/div[5]//a").each do |link|
              if !link['href'].nil?
                category_url = link['href']
                unless FashionCrawler::Models::Resource.where(url: category_url).exists?
                  FashionCrawler::Models::Resource.create({
                    url: category_url,
                    task: 'BloomingdalesProcessAtPagingPage',
                    is_visited: false,
                    site_name: 'Bloomingdales',
                    store: FashionCrawler::Models::Store.find_by(name: 'Bloomingdales')
                    })
                end
              end
            end
            doc.xpath("//*[@id='nav_category']/div[6]//a").each do |link|
              if !link['href'].nil?
                category_url = link['href']
                unless FashionCrawler::Models::Resource.where(url: category_url).exists?
                  FashionCrawler::Models::Resource.create({
                    url: category_url,
                    task: 'BloomingdalesProcessAtPagingPage',
                    is_visited: false,
                    site_name: 'Bloomingdales',
                    store: FashionCrawler::Models::Store.find_by(name: 'Bloomingdales')
                    })
                end
              end
            end
          elsif url.include?("SHOES")
            doc.xpath("//*[@id='nav_category']/div[3]//a").each do |link|
              if !link['href'].nil?
                category_url = link['href']
                unless FashionCrawler::Models::Resource.where(url: category_url).exists?
                  FashionCrawler::Models::Resource.create({
                    url: category_url,
                    task: 'BloomingdalesProcessAtPagingPage',
                    is_visited: false,
                    site_name: 'Bloomingdales',
                    store: FashionCrawler::Models::Store.find_by(name: 'Bloomingdales')
                    })
                end
              end
            end
          elsif url.include?("KIDS")
            doc.xpath("//*[@id='nav_category']/div[1]//a").each do |link|
              if !link['href'].nil?
                category_url = link['href']
                unless FashionCrawler::Models::Resource.where(url: category_url).exists?
                  FashionCrawler::Models::Resource.create({
                    url: category_url,
                    task: 'BloomingdalesProcessAtPagingPage',
                    is_visited: false,
                    site_name: 'Bloomingdales',
                    store: FashionCrawler::Models::Store.find_by(name: 'Bloomingdales')
                    })
                end
              end
            end
            doc.xpath("//*[@id='nav_category']/div[2]//a").each do |link|
              if !link['href'].nil?
                category_url = link['href']
                unless FashionCrawler::Models::Resource.where(url: category_url).exists?
                  FashionCrawler::Models::Resource.create({
                    url: category_url,
                    task: 'BloomingdalesProcessAtPagingPage',
                    is_visited: false,
                    site_name: 'Bloomingdales',
                    store: FashionCrawler::Models::Store.find_by(name: 'Bloomingdales')
                    })
                end
              end
            end
            doc.xpath("//*[@id='nav_category']/div[3]//a").each do |link|
              if !link['href'].nil?
                category_url = link['href']
                unless FashionCrawler::Models::Resource.where(url: category_url).exists?
                  FashionCrawler::Models::Resource.create({
                    url: category_url,
                    task: 'BloomingdalesProcessAtPagingPage',
                    is_visited: false,
                    site_name: 'Bloomingdales',
                    store: FashionCrawler::Models::Store.find_by(name: 'Bloomingdales')
                    })
                end
              end
            end
            doc.xpath("//*[@id='nav_category']/div[4]//a").each do |link|
              if !link['href'].nil?
                category_url = link['href']
                unless FashionCrawler::Models::Resource.where(url: category_url).exists?
                  FashionCrawler::Models::Resource.create({
                    url: category_url,
                    task: 'BloomingdalesProcessAtPagingPage',
                    is_visited: false,
                    site_name: 'Bloomingdales',
                    store: FashionCrawler::Models::Store.find_by(name: 'Bloomingdales')
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

    class BloomingdalesProcessAtPagingPage
      def self.execute(url, body)
        doc = Nokogiri::HTML(body)
        begin

          count = doc.at_xpath("//*[@id='productCount']/span")
          count = count.nil? ? 1 : count.text.strip.to_i/94 + 1

          (1..count).each do |index|
            paging_url = url.gsub(/\?id/, "/Pageindex,Sortby,Productsperpage/#{index.to_s},ORIGINAL,96?id")
            FashionCrawler::Models::Resource.create({
              url: paging_url,
              task: 'BloomingdalesProcessAtListPage',
              is_visited: false,
              site_name: 'Bloomingdales',
              store: FashionCrawler::Models::Store.find_by(name: 'Bloomingdales')
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

    class BloomingdalesProcessAtListPage
      def self.execute(url, body)
        doc = Nokogiri::HTML(body)
        begin

          category = url.gsub("http://www1.bloomingdales.com/shop/", "").gsub(/\/Pageindex(.)*/, "")

          doc.xpath("//*[@id='thumbnails']//a").each do |link|
            if !link['href'].nil? && link['href'].match("product")
              detail_url = "#{link['href']}&tmp=#{category}"
              unless FashionCrawler::Models::Resource.where(url: detail_url).exists?
                FashionCrawler::Models::Resource.create({
                  url: detail_url,
                  task: 'BloomingdalesProcessAtDetailPage',
                  is_visited: false,
                  site_name: 'Bloomingdales',
                  store: FashionCrawler::Models::Store.find_by(name: 'Bloomingdales')
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


    class BloomingdalesProcessAtDetailPage
      def self.execute(url, body)
        doc = Nokogiri::HTML(body)
        begin

          url2 = url.gsub(/\&tmp=(.)*/, "")
          product = FashionCrawler::Models::Item.where(link: url2).first
          if product.nil?
            item = FashionCrawler::Models::Item.new
            item.link = url2

            name = doc.at_xpath("//*[@id='productTitle']")
            unless name.nil?
              item.name = name.text.strip
              master_brand = MasterBrand.by_brand_name_include(item.name)
              unless master_brand.nil?
                item.brand_id = master_brand.brand_id
                item.brand_name = master_brand.brand_name
                item.brand_name_ja = master_brand.brand_name_ja
              end
            end

            item.site_id = 5
            item.site_name = "Bloomingdales"
            item.country_name = "US"
          else
            item = product
          end

          color_nodes = doc.at_xpath("//*[@class='colors']//li/@title")
          if color_nodes.nil?
            color_node = doc.at_xpath("//*[@id='colorHeadersDiv']/span[2]")
            item.colors = color_node.text.strip unless color_node.nil?
          else
            colors = []
            color_nodes.each do |color|
              unless color.nil?
                colors << color
              end
            end
            item.colors = colors.join(",")
          end

          description = doc.at_xpath("//*[@id='pdp_tabs_body_left']")
          item.description = description.text.strip unless description.nil?

          original_price = doc.at_xpath("//*[text()='Reg ']/following::span")
          unless original_price.nil?
            item.original_base_price = original_price.text.strip
            original_base_price = item.original_base_price.gsub("$","").gsub(",", "").to_f
            item.base_price = CurrencyRate.convert_to_yen("USD", original_base_price) if original_base_price != 0
          end

          price = doc.at_xpath("//*[@itemprop='price']")
          unless price.nil?
            item.original_price = price.text.strip.gsub("Now ", "").gsub("Sale ", "")
            price = item.original_price.gsub("$","").gsub(",", "").to_f
            item.price = CurrencyRate.convert_to_yen("USD", price)
          end

          image = doc.at_xpath("//*[@id='productImage']")
          item.images = image['src'] unless image.nil?

          category = url.scan(/(\&tmp=(.)+)/).join('')
          category = category.gsub("&tmp=","")[0..-2]

          check_category = BloomingdalesCategory.by_name(category)
          if check_category.present?
            item.category_id = check_category.category_id
          else
            check_category = BloomingdalesCategory.by_category_name(category)
            item.category_id = check_category.category_id if check_category.present?
          end

          master_category = MasterCategory.by_category_3_id(item.category_id.to_i)
          unless master_category.nil?
            item.category_name = master_category.category_3
            general_category_id = master_category.general_category_id
          end

          sizes = []
          doc.xpath("//*[@class='size regular']").each do |node|
            unless node['title'].nil?
              sizes << node['title']
            end
          end
          if sizes == []
            doc.xpath("//*[@class='size ']").each do |node|
              unless node['title'].nil?
                sizes << node['title']
              end
            end
          end
          if sizes == []
            size = doc.at_xpath("//*[@class='pdpSizeLabel']/following::span")
            item.original_size = size.nil? ? "" : size.text.strip
          else
            item.original_size = sizes.join(",")
          end
          if general_category_id.nil?
            item.size = item.original_size
          else
            item.size = MasterSize.convert_sizes(item.original_size, "US", general_category_id)
          end

          item.added_or_updated = true

          #### Check Stock ####################################################
          number_of_products = 0
          number_of_products = doc.inner_html.to_s.scan(/In Stock/).count()

          if number_of_products > 0
            item.flag = 1
            item.number_of_products = number_of_products
          else
            item.flag = 0
          end

          if !item.name.blank? && !item.brand_name.blank? && !item.price.blank?
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
