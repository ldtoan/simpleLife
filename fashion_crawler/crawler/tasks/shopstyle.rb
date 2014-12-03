# encoding: utf-8
require 'nokogiri'
require 'unicode'
require 'uri'
require 'date'
NBSP = Nokogiri::HTML("&nbsp;").text

NOCRAWLINKS = ["plus-size-jeans", "plus-size-dresses", "plus-size-intimates", "plus-size-jackets", "plus-size-outerwear", "plus-size-pants", "plus-size-shorts", "plus-size-skirts", "plus-size-sweatshirts", "plus-size-sweaters", "plus-size-swimsuits", "plus-size-tops", "baby-bouncers", "baby-gyms-and-playmats", "baby-playards", "baby-swings", "baby-travel-accessories", "baby-walkers", "backpack-frame-baby-carriers", "front-baby-carriers", "organic-baby-carriers", "baby-slings-and-wraps", "booster-baby-car-seats", "convertible-baby-car-seats", "infant-car-seats", "baby-car-seat-accessories", "baby-diapers", "baby-diapers", "baby-diaper-bags", "baby-diaper-bags", "baby-diaper-bags", "baby-diaper-bags", "baby-changing-pads", "baby-wipes-and-accessories", "bibs-and-burp-cloths", "bottle-feeding", "bottle-feeding", "breastfeeding", "feeding-chairs-and-seats", "baby-feeding-tableware", "baby-humidifiers", "baby-gates", "baby-household-safety", "baby-monitors", "baby-pacifiers-and-soothers", "baby-single-strollers", "baby-double-triple-strollers", "baby-jogging-strollers", "baby-travel-systems", "baby-stroller-accessories", "kids-boy-bedding", "kids-girl-bedding", "kids-bedding-mattresses-pads-and-covers", "kids-bedding-pillows", "kids-decor-clocks", "kids-decor-curtains", "kids-decor-desk-accessories", "kids-decor-hanging-decor", "kids-decor-lighting", "kids-decor-mirrors", "kids-decor-picture-frames", "kids-decor-rugs", "kids-beds-and-mattresses", "kids-bookcases", "kids-desks-charis", "kids-dressers-and-armoires", "kids-nightstands", "kids-storage-and-shelving", "toy-boxes-and-benches", "kids-miniature-vehicles", "kids-action-figures", "kids-models-and-kits", "kids-playmats", "baby-blocks-stackers-and-sorters", "crib-toys", "baby-learning-toys", "kids-rattles-and-teethers", "soft-and-plush-toys", "walkers-and-ride-ons", "baby-and-toddler-books", "books-for-mom-and-dad", "childrens-dvds", "childrens-music", "baby-and-toddler-dolls", "childrens-dolls", "dollhouses-and-accessories", "kids-stuffed-animals", "kids-board-games", "kids-puzzles", "kids-travel-games", "kids-card-games", "kids-arts-craft-toys", "kids-bricks-blocks", "kids-educational-toys", "kids-backyard-and-garden-play", "kids-beach-and-pool-play", "kids-bikes-and-ride-ons", "kids-safety-gears", "kids-sports-and-activities", "kids-play-food-and-cooking-toys", "kids-costumes", "kids-tools-toys", "kids-tents-and-tunnels", "kids-puppets", "baby-diaper-cakes", "baby-diaper-pails-and-refills", "baby-diaper-backpacks", "baby-diaper-messenger-bags", "baby-diaper-tote-bags", "baby-diaper-bags-for-dad", "feeding-bottles-and-nipples", "feeding-bottles-accessories"]

module FashionCrawler
  module Tasks
    class ShopStyleProcessAtMainPage
     def self.execute(url, body)
      doc = Nokogiri::HTML(body)
      begin
        doc.xpath("//a").each do |link|
          if !link['href'].nil? && link['href'].match(/Categories\?catId=/) && !link['href'].include?("living")
            category1 = link.text.strip
            url_cate1 = "http://www.shopstyle.co.uk#{link['href']}"
            unless FashionCrawler::Models::Resource.where(url: url_cate1).exists?
              FashionCrawler::Models::Resource.create({
                url: url_cate1,
                task: 'ShopStyleProcessAtCate1Page',
                is_visited: false,
                site_name: 'ShopStyle',
                store: FashionCrawler::Models::Store.find_by(name: 'ShopStyle')
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

    class ShopStyleProcessAtCate1Page
      def self.execute(url, body)
        doc = Nokogiri::HTML(body)
        begin

          doc.xpath("//*[@class='indentLevel2']//a").each do |link|
            if !link['href'].nil? && link['href'].match(/browse\//)
              path = link.path
              nextdom = doc.at_xpath(path + "/following::div")
              indent3_list = []
              while nextdom['class'] == "indentLevel3"
                path_2 = nextdom.path
                a = doc.at_xpath(path_2 + "/a")
                indent4_list = []
                nextdom_2 = doc.at_xpath(path_2 + "/following::div")
                while nextdom_2['class'] == "indentLevel4"
                  path_3 = nextdom_2.path
                  b = doc.at_xpath(path_3 + "/a")
                  if !NOCRAWLINKS.include?(b['href'].gsub("/browse/", ""))
                    indent4_list << b['href']
                  end
                  nextdom_2 = doc.at_xpath(path_3 + "/following::div")
                end
                if indent4_list.empty? && !NOCRAWLINKS.include?(a['href'].gsub("/browse/", ""))
                  indent3_list << a['href']
                else
                  indent4_list.each do |href|
                    url_cate2 = "http://www.shopstyle.co.uk#{href}"
                    unless FashionCrawler::Models::Resource.where(url: url_cate2).exists?
                      FashionCrawler::Models::Resource.create({
                        url: url_cate2,
                        task: 'ShopStyleProcessAtCate2Page',
                        is_visited: false,
                        site_name: 'ShopStyle',
                        store: FashionCrawler::Models::Store.find_by(name: 'ShopStyle')
                        })
                    end
                  end
                  indent3_list = ["yes"]
                end
                nextdom = doc.at_xpath(path_2 + "/following::div")
              end
              if indent3_list.empty?
                if !NOCRAWLINKS.include?(link['href'].gsub("/browse/", ""))
                  url_cate2 = "http://www.shopstyle.co.uk#{link['href']}"
                  unless FashionCrawler::Models::Resource.where(url: url_cate2).exists?
                    FashionCrawler::Models::Resource.create({
                      url: url_cate2,
                      task: 'ShopStyleProcessAtCate2Page',
                      is_visited: false,
                      site_name: 'ShopStyle',
                      store: FashionCrawler::Models::Store.find_by(name: 'ShopStyle')
                      })
                  end
                end
              elsif indent3_list != ["yes"]
                indent3_list.each do |href|
                  url_cate2 = "http://www.shopstyle.co.uk#{href}"
                  unless FashionCrawler::Models::Resource.where(url: url_cate2).exists?
                    FashionCrawler::Models::Resource.create({
                      url: url_cate2,
                      task: 'ShopStyleProcessAtCate2Page',
                      is_visited: false,
                      site_name: 'ShopStyle',
                      store: FashionCrawler::Models::Store.find_by(name: 'ShopStyle')
                      })
                  end
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

    class ShopStyleProcessAtCate2Page
      def self.execute(url, body)
        doc = Nokogiri::HTML(body)
        begin
          category = url.gsub("http://www.shopstyle.co.uk/browse/", "").gsub(/\?page(.)*/,"")
          base = body.scan(/\/action\/rawProducts\?cat=[\d]+&largeCell=[\d]+&size=Large/)[0].to_s
          page_number = url.include?("pageNumber") ? url.gsub(/(.)*pageNumber=/, "").to_i : 1
          min = (page_number - 1) * 400
          url_list = "http://www.shopstyle.co.uk#{base}&min=#{min}&count=400&vscroll=true&ssAjax=1&tmp=#{category}"
          FashionCrawler::Models::Resource.create({
            url: url_list,
            task: 'ShopStyleProcessAtListPage',
            is_visited: false,
            site_name: 'ShopStyle',
            store: FashionCrawler::Models::Store.find_by(name: 'ShopStyle')
            })

          doc.xpath("//*[@id='seeMoreBar']//a").each do |link|
            if !link['href'].nil? && link['href'].match(/pageNumber=/)
              url_paging = "http://www.shopstyle.co.uk#{link['href']}"
              unless FashionCrawler::Models::Resource.where(url: url_paging).exists?
                FashionCrawler::Models::Resource.create({
                  url: url_paging,
                  task: 'ShopStyleProcessAtCate2Page',
                  is_visited: false,
                  site_name: 'ShopStyle',
                  store: FashionCrawler::Models::Store.find_by(name: 'ShopStyle')
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

    class ShopStyleProcessAtListPage
      def self.execute(url, body)
        doc = Nokogiri::HTML(body)
        begin
          category = url.scan(/(&tmp=(.)+)/).join('')
          category = category.gsub("&tmp=","")[0..-2]
          doc.xpath("//*[@class='social-container']/a").each do |link|
            if !link['href'].nil? && link['href'].match(/p\/(.)*\/[\d]+/)
              url_detail = "http://www.shopstyle.co.uk#{link['href']}?tmp=#{category}"
              unless FashionCrawler::Models::Resource.where(url: url_detail).exists?
                FashionCrawler::Models::Resource.create({
                  url: url_detail,
                  task: 'ShopStyleProcessAtDetailPage',
                  is_visited: false,
                  site_name: 'ShopStyle',
                  store: FashionCrawler::Models::Store.find_by(name: 'ShopStyle')
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

    class ShopStyleProcessAtDetailPage
      def self.execute(url, body)
        doc = Nokogiri::HTML(body)
        begin
          check_farfetch = doc.xpath("//span[@class='retailerName']")
          check_farfetch = check_farfetch.present? ? check_farfetch.text : ""

          unless check_farfetch.downcase.include?("farfetch")
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

              ### check if master_brand nil or it will show error sometimes
              unless master_brand.nil?
                item.brand_id = master_brand.brand_id
                item.brand_name = item.brand_id == 100000 ? brand : master_brand.brand_name
                item.brand_name_ja = master_brand.brand_name_ja.nil? ? "" : master_brand.brand_name_ja

                item.country_name  = "UK"
                item.site_id = 1
                item.site_name = "SHOPSTYLE"

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

            color_nodes = doc.xpath("//*[@class='detailsColorText']")
            unless color_nodes.nil?
              colors = ""
              color_nodes.each_with_index do |node, i|
                colors << node.text.strip
              end
              item.colors = colors.gsub(/\n|\s|\t/,"")
            end

            description = doc.at_xpath("//*[@itemprop='description']")
            item.description = description.text.strip unless description.nil?

            original_price = doc.at_xpath("//*[@class='productPrice']//*[@class='originalPrice']")
            unless original_price.nil?
              item.original_base_price = original_price.text.strip
              item.base_price = CurrencyRate.convert_price_to_yen("UK", item.original_base_price, "£")
            end

            price = doc.at_xpath("//*[@itemprop='price']")
            unless price.nil?
              item.original_price = price.text.strip
              item.price = CurrencyRate.convert_price_to_yen("UK", item.original_price, "£")
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

            sizes_node = doc.at_xpath("//*[@class='detailsSizes']")
            item.original_size = MasterSize.standardize_size(sizes_node.text.strip.gsub(/\n|\s|\t/,"").gsub(NBSP,"")) unless sizes_node.nil?
            unless item.original_size.nil?
              if general_category_id.nil?
                item.size = item.original_size
              else
                item.size = MasterSize.convert_sizes(item.original_size, "UK", general_category_id)
              end
            end

            ## check product have in stock with convention: 1 have in stock, 0 haven't in stock
            check_stock = doc.xpath("//span[@class='priceLabel soldOut']")
            if check_stock.present?
              item.flag = 0
              puts "Have in stock: #{item.flag} with links #{url2}"
            else
              item.flag = 1
            end

            if item.name.present? && item.brand_name.present? && item.price.present? && item.flag == 1
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
