# encoding: utf-8
require 'nokogiri'
require 'unicode'
require 'uri'
require 'date'

CATEGORIES_STYLEBOP = ["clothing", "shoes", "accessories", "bags", "lingerie"]

module FashionCrawler
  module Tasks
    class StylebopProcessAtMainPage
     def self.execute(url, body)
      begin
        ["http://www.stylebop.com/jp/women/", "http://www.stylebop.com/jp/men/"].each do |link|
          FashionCrawler::Models::Resource.create({
            url: link,
            task: 'StylebopProcessAtCatePage',
            is_visited: false,
            site_name: 'Stylebop',
            store: FashionCrawler::Models::Store.find_by(name: 'Stylebop')
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


    class StylebopProcessAtCatePage
      def self.execute(url, body)
        doc = Nokogiri::HTML(body)
        begin
          doc.xpath("//a[@class='link_mainmenu']").each do |link|
            unless link['href'].nil?
              match = false
              CATEGORIES_STYLEBOP.each do |category|
                match = true if link['href'].match(category)
              end
              if match == true
                category_url = link['href']
                unless FashionCrawler::Models::Resource.where(url: category_url).exists?
                  FashionCrawler::Models::Resource.create({
                    url: category_url,
                    task: 'StylebopProcessAtCatePage1',
                    is_visited: false,
                    site_name: 'Stylebop',
                    store: FashionCrawler::Models::Store.find_by(name: 'Stylebop')
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

    class StylebopProcessAtCatePage1
      def self.execute(url, body)
        doc = Nokogiri::HTML(body)
        begin
        doc.xpath("//*[@id='menuleft_content']//a").each do |link|
            if !link['href'].nil? && !link['href'].match("/all/") && !link['href'].match("fine-jewelery") && !link['href'].match("shop-by-designer")
              category_url = link['href']
              unless FashionCrawler::Models::Resource.where(url: category_url).exists?
                FashionCrawler::Models::Resource.create({
                  url: category_url,
                  task: 'StylebopProcessAtPagingPage',
                  is_visited: false,
                  site_name: 'Stylebop',
                  store: FashionCrawler::Models::Store.find_by(name: 'Stylebop')
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

    class StylebopProcessAtPagingPage
      def self.execute(url, body)
        doc = Nokogiri::HTML(body)
        begin
          if url.match(/tmp/)
            category = url.scan(/(\&tmp=(.)+)/).join('')
            category = category.gsub("&tmp=","")[0..-2]
          else
            category = url.gsub("http://www.stylebop.com/jp/", "")
          end

          doc.xpath("//*[@itemprop='url']").each do |link|
            unless link['href'].nil?
              detail_url = "#{link['href']}&tmp=#{category}"
              unless FashionCrawler::Models::Resource.where(url: detail_url).exists?
                FashionCrawler::Models::Resource.create({
                url: detail_url,
                task: 'StylebopProcessAtDetailPage',
                is_visited: false,
                site_name: 'Stylebop',
                store: FashionCrawler::Models::Store.find_by(name: 'Stylebop')
                })
              end
            end
          end

          if url.include?("search")
            base_url = url.gsub(/&page=[\d]+/, "")
          else
            tmp = body.scan(/menu1=[\w]+&menu2=[\d]+&menu3=[\d]+/)
            if tmp.empty?
              tmp = body.scan(/menu1=[\w]+&menu2=[\d]+/)
            end
            if doc.at_xpath("//*[@class='MenuLeft2New']").blank?
              tmp = tmp.first
            else
              tmp = tmp.first.gsub(/&menu3=[\d]+/, "")
            end
            base_url = "http://www.stylebop.com/jp/search.php?state=1&#{tmp}"
          end

          doc.xpath("//*[@class='page']").each do |node|
            page = node.text.strip
            if !page.blank? && page != "1"
              paging_url = "#{base_url}&page=#{page}&tmp=#{category}"
              unless FashionCrawler::Models::Resource.where(url: paging_url).exists?
                FashionCrawler::Models::Resource.create({
                url: paging_url,
                task: 'StylebopProcessAtPagingPage',
                is_visited: false,
                site_name: 'Stylebop',
                store: FashionCrawler::Models::Store.find_by(name: 'Stylebop')
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

    class StylebopProcessAtDetailPage
      def self.execute(url, body)
        doc = Nokogiri::HTML(body)
        begin

          url2 = url.gsub(/\&tmp=(.)*/, "")
          product = FashionCrawler::Models::Item.where(link: url2).first
          if product.nil?
            item = FashionCrawler::Models::Item.new
            item.link = url2
            name = doc.at_xpath("//*[@class='caption_designer']")
            unless name.nil?
              name = name.text.strip
              master_brand = MasterBrand.by_brand_name(name)
              unless master_brand.nil?
                item.brand_id = master_brand.brand_id
                item.brand_name = MasterBrand.id_is_other?(item.brand_id) ? name : master_brand.brand_name
                item.brand_name_ja = master_brand.brand_name_ja
                name_2 = doc.at_xpath("//*[@class='caption_designer']/following::span")
                name_2 = name_2.text.strip unless name_2.nil?
                item.name = "#{name} #{name_2}"
              end
            end
            item.site_id = 8
            item.site_name = "Stylebop"
            item.country_name = "Europe"
          else
            item = product
          end

          description = doc.at_xpath("//*[@id='product_details_data']")
          item.description = description.text.strip unless description.nil?

          base_price = doc.at_xpath("//*[@id='product_price']/*[@class='old_price']")
          if base_price.nil?
            price = doc.at_xpath("//*[@id='product_price']")
            item.price = price.text.strip.gsub(/(\s|\t|\n)/, "").gsub(/¥|\./, "").gsub(/\/€(.)*/, "").to_f unless price.nil?

            original_price = doc.at_xpath("//*[@id='product_price']/span")
            item.original_price = original_price.text.gsub(/\./, "").strip unless original_price.nil?
          else
            item.base_price = base_price.text.gsub("¥", "").strip.to_f
            price = doc.at_xpath("//*[@id='product_price']/*[@class='sale_price']")
            item.price = price.text.strip.gsub(/\s/, "").gsub(/¥|\./, "").gsub(/\((.)*/, "").to_f unless price.nil?
            original_price = doc.at_xpath("//*[@id='product_price']/span[3]")
            item.original_price = original_price.text.strip unless original_price.nil?
          end

          image_nodes = []
          main_img = doc.at_xpath("//img[@class='myClipViewer']")
          image_nodes << main_img["src"] if main_img.present? && main_img["src"].present?

          doc.xpath("//img").each do |img|
            if img["src"].match("130x216") || img["src"].match("640x806")
              unless img["src"].match(/http/)
                img["src"] = "http://www.stylebop.com/jp/" + img["src"]
              end
              img["src"] = img["src"].gsub("130x216","272x610")
              image_nodes << img["src"] unless image_nodes.index(img["src"])
            elsif img["src"].match(/big/)
              unless img["src"].match(/http/)
                img["src"] = "http://www.stylebop.com/jp/" + img["src"]
                image_nodes << img["src"] unless image_nodes.index(img["src"])
              end
            end
          end
          item.images = image_nodes.join(",")
          category = url.scan(/(\&tmp=(.)+)/).join('')
          category = category.gsub("&tmp=","")[0..-2]
          category = category.split("&page")[0] if category.include?("&page")
          category = category.split("/").uniq.join("/") if category.include?("/")

          check_category = StylebopCategory.by_name(category)
          if check_category.present?
            item.category_id = check_category.category_id
          else
            check_category = StylebopCategory.by_category_name(category)
            item.category_id = check_category.category_id if check_category.present?
          end

          master_category = MasterCategory.by_category_3_id(item.category_id.to_i)
          unless master_category.nil?
            item.category_name = master_category.category_3
            general_category_id = master_category.general_category_id
          end

          sizes = []
          doc.xpath("//*[@id='product_size']//option").each do |node|
            size = node.text.strip
            if !size.match("CHOOSE")
              sizes << size.gsub(" » add to Waiting List", "")
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

          item.added_or_updated = true


          #### Check Stock ####################################################
          number_of_products = 0
          doc.xpath("//option").each do |option|
            if option.text.match(/ONE SIZE/)
              number_of_products = 3
              break
            end
            unless option["value"] == "0"
              unless option.text.match(/add to Waiting List/)
                 number_of_products = number_of_products + 1
              end
            end
          end

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
