# encoding: utf-8
require 'nokogiri'
require 'unicode'
require 'uri'
require 'date'

# require 'pry'

CATEGORIES_FARFETCH = ["/clothing-1", "/shoes-1", "/accessories-1", "/bags-purses-1", "/jewellery-1", "/clothing-2", "/shoes-2", "/accessories-2", "/bags-purses-2", "/jewellery-2" ]
NOCRAWL_FARFETCH = ["/lace-up-shoe-1", "women/trousers-1", "women/tops-1", "women/lingerie-hosiery-1", "women/jackets-1", "women/dresses-1", "women/denim-1", "women/coats-1", "men/jackets-2", "men/denim-2", "men/hi-tops-2", "men/lace-up-2"]
module FashionCrawler
  module Tasks
    class FarfetchProcessAtMainPage
     def self.execute(url, body)
      begin
        ["http://www.farfetch.com/jp/shopping/men/items.aspx"].each do |link|
        FashionCrawler::Models::Resource.create({
          url: link,
          task: 'FarfetchProcessAtCatePage',
          is_visited: false,
          site_name: 'Farfetch',
          store: FashionCrawler::Models::Store.find_by(name: 'Farfetch')
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


    class FarfetchProcessAtCatePage
      def self.execute(url, body)
        doc = Nokogiri::HTML(body)
        begin
          doc.xpath("//*[@href='/jp/shopping/men']/following-sibling::ul//a").each do |link|
            if link['href'].present? && !link['href'].match("newin") && !link['href'].match("sale")
              match = false
              CATEGORIES_FARFETCH.each do |category|
                match = true if link['href'].match(category)
              end
              if match == true
                category_url = "http://www.farfetch.com#{link['href']}"
                puts "Link men: #{link['href']}"
                unless FashionCrawler::Models::Resource.where(url: category_url).exists?
                  FashionCrawler::Models::Resource.create({
                    url: category_url,
                    task: 'FarfetchProcessAtCatePage1',
                    is_visited: false,
                    site_name: 'Farfetch',
                    store: FashionCrawler::Models::Store.find_by(name: 'Farfetch')
                    })
                end
              end
            end
          end

          doc.xpath("//*[@href='/jp/shopping/women']/following-sibling::ul//a").each do |link|
            if link['href'].present? && !link['href'].match("newin") && !link['href'].match("sale")
              match = false
              CATEGORIES_FARFETCH.each do |category|
                match = true if link['href'].match(category)
              end
              if match == true
                category_url = "http://www.farfetch.com#{link['href']}"
                puts "Link women: #{link['href']}"
                unless FashionCrawler::Models::Resource.where(url: category_url).exists?
                  FashionCrawler::Models::Resource.create({
                    url: category_url,
                    task: 'FarfetchProcessAtCatePage1',
                    is_visited: false,
                    site_name: 'Farfetch',
                    store: FashionCrawler::Models::Store.find_by(name: 'Farfetch')
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

    class FarfetchProcessAtCatePage1
      def self.execute(url, body)
        doc = Nokogiri::HTML(body)
        begin
          doc.xpath("//*[@id='FilterListf30d2']//a").each do |link|
            if !link['href'].nil?
              match = true
              NOCRAWL_FARFETCH.each do |category|
                match = false if link['href'].match(category)
              end
              if match == true
                category_url = "http://www.farfetch.com#{link['href']}"
                unless FashionCrawler::Models::Resource.where(url: category_url).exists?
                  FashionCrawler::Models::Resource.create({
                    url: category_url,
                    task: 'FarfetchProcessAtPagingPage',
                    is_visited: false,
                    site_name: 'Farfetch',
                    store: FashionCrawler::Models::Store.find_by(name: 'Farfetch')
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

    class FarfetchProcessAtPagingPage
      def self.execute(url, body)
        doc = Nokogiri::HTML(body)
        begin

          category = url.gsub("http://www.farfetch.com/jp/shopping/", "").gsub(/\?(.)*/, "").gsub(/\/pv-(.)*/, "").gsub(/\/items(.)*/, "").gsub("/", "-")

          doc.xpath("//*[@id='listingItems']//a").each do |link|
            if link['href'].present? && !link['href'].match("_&vd=") && !link['href'].include?("filters")
              detail_url = "http://www.farfetch.com#{link['href']}&tmp=#{category}"
              unless FashionCrawler::Models::Resource.where(url: detail_url).exists?
                FashionCrawler::Models::Resource.create({
                url: detail_url,
                task: 'FarfetchProcessAtDetailPage',
                is_visited: false,
                site_name: 'Farfetch',
                store: FashionCrawler::Models::Store.find_by(name: 'Farfetch')
                })
              end
            end
          end

          link = doc.at_xpath("//*[@id='PagingSelectorItemNext']")
          unless link.nil?
            paging_url = "http://www.farfetch.com#{link['href']}"
            unless FashionCrawler::Models::Resource.where(url: paging_url).exists?
              FashionCrawler::Models::Resource.create({
                url: paging_url,
                task: 'FarfetchProcessAtPagingPage',
                is_visited: false,
                site_name: 'Farfetch',
                store: FashionCrawler::Models::Store.find_by(name: 'Farfetch')
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

    class FarfetchProcessAtDetailPage
      def self.execute(url, body)
        doc = Nokogiri::HTML(body)
        begin

          url2 = url.gsub(/\&tmp=(.)*/, "").gsub(/&ffref=\S+/, "")
          product = FashionCrawler::Models::Item.where(link: url2).first
          if product.nil?
            item = FashionCrawler::Models::Item.new
            item.link = url2
            name = doc.at_xpath("//*[@itemprop='name']")
            item.name = name.text.strip unless name.nil?
            brand = doc.at_xpath("//*[@itemprop='brand']")
            unless brand.nil?
              brand = brand.text.strip
              master_brand = MasterBrand.by_brand_name(brand)
              unless master_brand.nil?
                item.brand_id = master_brand.brand_id
                item.brand_name = MasterBrand.id_is_other?(item.brand_id) ? brand : master_brand.brand_name
                item.brand_name_ja = master_brand.brand_name_ja
              end
            end
            item.site_id = 10
            item.site_name = "Farfetch"
          else
            item = product
          end

          ### get material
          parse_material = doc.xpath("//div[3]/div[2]/dl/dd[1]")
          parse_material2 = doc.xpath("//dl[@class='productDetailModule-accordion-dl ']")[1]
          if parse_material.present?
            if parse_material.text.present? && parse_material.text.match(/100%/).present?
              puts "#{parse_material.text} with link: #{url2}"
              item.material_ja = parse_material.text.squish
            else
              if parse_material2.present?
                material_arr = []
                parse_material2.children.each do |material|
                  if material.children.present? && material.children.text.match(/[0-9]+%/).present?
                    material_arr << material.children.text
                  end
                end
                puts "#{material_arr.join(",")} with link: #{url2}"
                item.material_ja = material_arr.present? ? material_arr.join(",") : ""
              end
            end
          end

          description = doc.at_xpath("//*[@data-tstid='Content_Description']/p")
          item.description = description.text.strip unless description.nil?

          price = doc.at_xpath("//*[@class='detail-price ']//span[@class='color-red listing-sale']")
          if price.nil?
            price = doc.at_xpath("//*[@class='detail-price ']/span")
          else
            base_price = doc.at_xpath("//*[@class='detail-price ']/span")
            item.original_base_price = base_price.text.strip
            item.base_price = item.original_base_price.gsub(/,|¥/, "").to_f unless base_price.nil?
          end

          unless price.nil?
            item.original_price = price.text.strip
            item.price = item.original_price.gsub(/,|¥/, "").to_f
          end

          image_nodes = []
          doc.xpath("//div[@class='sliderProductModule']//img").each do |node|
            href = node['data-zoom-image']
            unless href.nil?
              image_nodes << href unless image_nodes.include?(href)
            end
          end
          item.images = image_nodes.join(",")
          category = url.scan(/(\&tmp=(.)+)/).join('')
          category = category.gsub("&tmp=","")[0..-2]
          item.category_id = FarfetchCategory.by_name(category).category_id
          master_category = MasterCategory.by_category_3_id(item.category_id.to_i)
          unless master_category.nil?
            item.category_name = master_category.category_3
            general_category_id = master_category.general_category_id
          end

          sizes = []
          check_sizes = doc.xpath('//*[@class="dropdown customdropdown dropdown-no-border"]//*[@id="detailSizeDropdown"]//span[@class="productDetailModule-dropdown-numberItems"]')
          check_stock = doc.xpath('//*[@class="dropdown customdropdown dropdown-no-border"]//*[@id="detailSizeDropdown"]//span[@class="productDetailModule-dropdown-leftInStock"]')

          if check_sizes.present? || check_stock.present?

            if check_sizes.present? && check_stock.present?
              count_number_size = 0
              check_sizes.each do |detail_size|
                count_number_size += 1
              end
              count_number_stock = 0
              number_of_products = 0
              check_stock.each do |detail_stock|
                parse_stocks = detail_stock.text.match(/[0-9]+/)
                number_of_products += parse_stocks[0].to_i if parse_stocks.present?
                count_number_stock += 1 if parse_stocks.present?
              end

              if count_number_stock != count_number_size
                # puts "-----------------------------------------------------------------"
                number_of_products += 3 * (count_number_size - count_number_stock)
                item.number_of_products = number_of_products
                # puts "Number of number stock: #{number_of_products} with url: #{url2}"
                # puts "-----------------------------------------------------------------"
              else
                # puts "======== Number of product: #{number_of_products} with url: #{url2}"
                item.number_of_products = number_of_products
              end
            end

            if check_sizes.present? && !check_stock.present?
              item.number_of_products = 3
              # puts "====|||||||||||| No stock: 5 with url: #{url2}"
            end

            doc.xpath("//*[@class='productDetailModule-dropdown-numberItems']").each do |node|
              size = node.text.strip.delete(NBSP).gsub(/\s/, "")
              if size != "-"
                sizes << size unless sizes.include?(size)
              end
            end
            unless sizes.empty?
              item.original_size = sizes.join(",")
              if general_category_id.nil?
                item.size = item.original_size
              else
                item.size = MasterSize.convert_sizes(item.original_size, "US", general_category_id)
              end
            end
            puts "Have stock: #{url2}"
            item.flag = 1
          else
            puts "----------------------Haven't stock: #{url2}"
            item.flag = 0
          end

          if item.original_price.gsub(/,|¥/,"").to_i > 1000000
            item.flag = 0
          end

          if item.name.present? && item.brand_name.present? && item.price.present? && item.flag == 1
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
