# encoding: utf-8
require 'nokogiri'
require 'unicode'
require 'uri'
require 'date'
require 'open-uri'

BIG_CATEGORY = ["clothing", "shoes", "bags", "accessories"]
def is_big_category(name)
 BIG_CATEGORY.each do |text|
   return true if name.strip == text.strip
 end
 return false
end

module FashionCrawler
  module Tasks
    class SHOPBOPProcessAtMainPage
     def self.execute(url, body)
      doc = Nokogiri::HTML(body)
      begin
        doc.xpath("//*[@id='navList']//a").each do |link|
          if !link['href'].nil? && is_big_category(link['data-cs-name'])
            url_cate1 = "http://www.shopbop.com#{link['href']}"
            unless FashionCrawler::Models::Resource.where(url: url_cate1).exists?
              FashionCrawler::Models::Resource.create({
                url: url_cate1,
                task: 'SHOPBOPProcessAtCate1Page',
                is_visited: false,
                site_name: 'SHOPBOP',
                store: FashionCrawler::Models::Store.find_by(name: 'SHOPBOP')
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

    class SHOPBOPProcessAtCate1Page
      def self.execute(url, body)
        doc = Nokogiri::HTML(body)
        begin
          doc.xpath("//*[@id='leftNavigation']//a").each do |link|
            if !link['href'].nil? && link.text.strip != "Shop All"
            # if !link['href'].nil? && link['href'].match("shoes-wedges")
              url_cate = "http://www.shopbop.com#{link['href']}"
              unless FashionCrawler::Models::Resource.where(url: url_cate).exists?
                #puts "-----------#{url_cate}---------------"
                FashionCrawler::Models::Resource.create({
                  url: url_cate,
                  task: 'SHOPBOPProcessAtCate2Page',
                  is_visited: false,
                  site_name: 'SHOPBOP',
                  store: FashionCrawler::Models::Store.find_by(name: 'SHOPBOP')
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

    class SHOPBOPProcessAtCate2Page
      def self.execute(url, body)
        doc = Nokogiri::HTML(body)
        begin
          base_url = url.gsub("http://www.shopbop.com", "")
          ul = doc.at_xpath("//a[@href='#{base_url}']/parent::li/ul")
          if ul.nil? && !url.include?("clothes-leather")
            # puts "-------#{url}------------------------------------"
            FashionCrawler::Models::Resource.create({
              url: url,
              task: 'SHOPBOPProcessAtListPage',
              is_visited: false,
              site_name: 'SHOPBOP',
              store: FashionCrawler::Models::Store.find_by(name: 'SHOPBOP')
              })
          else
            doc.xpath("#{ul.path}//a").each do |link|
              if !link['href'].nil? && !link['href'].include?("dresses-designer-boutique") && !link['href'].include?("clothing-denim-all-jeans") && !link['href'].include?("clothing-jackets-coats") && !link['href'].include?("accessories-trend-new-pearls")
                url_cate = "http://www.shopbop.com#{link['href']}"
                unless FashionCrawler::Models::Resource.where(url: url_cate).exists?
                   # puts "-------#{url_cate}------------------------------------"
                  FashionCrawler::Models::Resource.create({
                    url: url_cate,
                    task: 'SHOPBOPProcessAtListPage',
                    is_visited: false,
                    site_name: 'SHOPBOP',
                    store: FashionCrawler::Models::Store.find_by(name: 'SHOPBOP')
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
          FashionCrawler::Models::Resource.where(url: url, task: "SHOPBOPProcessAtCate2Page").update_all(is_visited: true)
        end
      end
    end


    class SHOPBOPProcessAtListPage
      def self.execute(url, body)
        doc = Nokogiri::HTML(body)
        begin
          category = url.gsub("http://www.shopbop.com/", "").gsub(/\/br(.)*/,"")
          doc.xpath("//a[@class=' url']").each do |link|
            if !link['href'].nil? && link['href'].match(/\d+.htm/)
              url_detail = link['href'].gsub(/folderID=(.)*&color/, "color")
              url_detail = "http://www.shopbop.com#{url_detail}&tmp=#{category}"
              unless FashionCrawler::Models::Resource.where(url: url_detail).exists?
                puts "Detail url!!!!!!!!!!!!!!!!!!#{url_detail}!!!!!!!!!!!!!!!!!!!"
                FashionCrawler::Models::Resource.create({
                  url: url_detail,
                  task: 'SHOPBOPProcessAtDetailPage',
                  is_visited: false,
                  site_name: 'SHOPBOP',
                  store: FashionCrawler::Models::Store.find_by(name: 'SHOPBOP')
                  })
              end
            end
          end
          doc.xpath("//*[@data-cs-name='browse-next']").each do |link|
            if !link['data-next-link'].nil?
              url_paging = "http://www.shopbop.com#{link['data-next-link']}"
              unless FashionCrawler::Models::Resource.where(url: url_paging).exists?
                FashionCrawler::Models::Resource.create({
                  url: url_paging,
                  task: 'SHOPBOPProcessAtListPage',
                  is_visited: false,
                  site_name: 'SHOPBOP',
                  store: FashionCrawler::Models::Store.find_by(name: 'SHOPBOP')
                  })
              end
            end
          end

        rescue => e
          puts e.inspect
          puts e.backtrace
        ensure
          #change the link status
          FashionCrawler::Models::Resource.where(url: url, task: "SHOPBOPProcessAtListPage").update_all(is_visited: true)
        end
      end
    end

    class SHOPBOPProcessAtDetailPage
      def self.execute(url, body)
        doc = Nokogiri::HTML(body)
        begin
          url2 = url.gsub(/&tmp=(.)*/, "")
          product = FashionCrawler::Models::Item.where(link: url2).first
          if product.nil?

            num_item = 0
            one_size = doc.at_xpath("//span[text()='One Size']")
            if one_size.present?
              num_item = num_item + 3
            end

            ### get list color
            doc.xpath("//div[@id='swatches']//img").each do |img|
              color_id = img["id"].to_s.scan(/(\d+)/).join('')
              product_id = img["src"].to_s.scan(/(\w+)_sw_\S+.jpg/).join('').gsub(color_id,'')
              ### get list size according color
              doc.xpath("//div[@id='sizes']//span").each do |size|
                size_id = size["id"]
                url_request = "http://www.shopbop.com/actions/availabilityCheck.action?product=#{product_id}&size=#{size_id}&color=#{color_id}"
                item_hash = JSON::parse(open(url_request).read)["responseData"]
                num_item = num_item + item_hash["available"].to_i
              end
            end

            item = FashionCrawler::Models::Item.new

            if num_item > 0
              item.number_of_products = num_item
              item.flag = 1
            else
              item.number_of_products = 0
              item.flag = 0
            end

            item.link = url2
            item.country_name  = "US"
            item.site_id = 4
            item.site_name = "SHOPBOP"

            name = doc.at_xpath("//*[@id='product-information']//*[@itemprop='name']")
            item.name = name.text.strip unless name.nil?

            brand = doc.at_xpath("//*[@id='product-information']//*[@itemprop='brand']")
            unless brand.nil?
              brand = brand.text.strip
              master_brand = MasterBrand.by_brand_name(brand)
              unless master_brand.nil?
                item.brand_id = master_brand.brand_id
                item.brand_name = item.brand_id == 100000 ? brand : master_brand.brand_name
                item.brand_name_ja = master_brand.brand_name_ja.nil? ? "" : master_brand.brand_name_ja
              end
            end

            script_node = doc.at_xpath("//*[@id='designersThickBoxcontainer']/following::script")
            unless script_node.nil?
              script = script_node.text.strip.gsub(/(\n|\t)/, "")
              # get colors
              item.colors = script.gsub(/(.)*colorName":/, "").gsub(/"(\s|,|")*color"(.)*/, "").gsub(/\s"/,"")
              #get images
              script = script.gsub(/(.)*"images/, "{\"images").gsub(/"video(.)*/, "").gsub("},","}}")
              json_data = JSON.parse(script)
              images = []
              i = 1
              while i < 6
                unless json_data["images"]["slot-#{i.to_s}"].nil?
                  images << json_data["images"]["slot-#{i.to_s}"]["main"]
                end
                i += 1
              end
              item.images = images.join(",")
            end
          else
            item = product
          end
          duplicated_item = FashionCrawler::Models::Item.where(site_id: 4, name: item.name, brand_name: item.brand_name).first
          if duplicated_item.nil?
            category = url.scan(/(&tmp=(.)+)/).join('')
            category = category.gsub("&tmp=","")[0..-2]
            item.category_id = ShopbopCategory.by_name(category).category_id
            master_category = MasterCategory.by_category_3_id(item.category_id.to_i)
            unless master_category.nil?
              item.category_name = master_category.category_3
              if item.category_name.nil?
                item.category_name = master_category.category_2
              end
              general_category_id = master_category.general_category_id
            end

            description = doc.at_xpath("//*[@itemprop='description']")
            item.description = description.text.strip unless description.nil?

            base_price = doc.at_xpath("//*[@class='originalRetailPrice']")
            unless base_price.nil?
              item.original_base_price = base_price.text.strip.gsub(/\s|\t|\n/,"").gsub(/(.)*\|/,"").gsub(/Payment(.)*/, "")
              item.base_price = CurrencyRate.convert_price_to_yen("USD", item.original_base_price, "$")
              if item.base_price == 0
                item.base_price = item.original_base_price.gsub(/¥|,/, "").to_f
              end
            end

            price = doc.at_xpath("//*[@id='productPrices']//*[@class='salePrice']")
            if price.nil?
              price = doc.at_xpath("//*[@id='productPrices']")
            end
            unless price.nil?
              item.original_price = price.text.strip.gsub(/\s|\t|\n/,"").gsub(/(.)*\|/,"").gsub(/Payment(.)*/, "")
              item.price = CurrencyRate.convert_price_to_yen("USD", item.original_price, "$")
              if item.price == 0
                puts item.price = item.original_price.gsub(/¥|,/, "").to_f
              end
            end

            sizes_node = doc.xpath("//*[@id='sizes']//span")
            unless sizes_node.nil?
              sizes = []
              sizes_node.each do |node|
                sizes << node.text.strip
              end
              item.original_size = sizes.join(",")
              if general_category_id.nil?
                item.size = item.original_size
              else
                item.size = MasterSize.convert_sizes(item.original_size, "US", general_category_id)
              end
            end

            if !item.name.blank? && !item.brand_name.blank? && !item.price.blank? && item.flag == 1
              item.save!
              puts 'added'
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
