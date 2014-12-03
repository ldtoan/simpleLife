# encoding: utf-8
require 'nokogiri'
require 'unicode'
require 'uri'
require 'date'
require 'open-uri'

module FashionCrawler
  module Tasks
    class MrporterProcessAtMainPage
      def self.execute(url, body)
        begin
          list_cate = ["http://www.mrporter.com/en-vn/mens/clothing/casual_shirts/checked_shirts?category=170",
                    "http://www.mrporter.com/en-vn/mens/clothing/casual_shirts/plain_shirts?category=170",
                    "http://www.mrporter.com/en-vn/mens/clothing/casual_shirts/printed_shirts?category=170",
                    "http://www.mrporter.com/en-vn/mens/clothing/casual_shirts/striped_shirts?category=170",
                    "http://www.mrporter.com/en-vn/mens/clothing/casual_shirts/long_sleeved_shirts?category=170",
                    "http://www.mrporter.com/en-vn/mens/clothing/casual_shirts/short_sleeved_shirts?category=170",
                    "http://www.mrporter.com/en-vn/mens/clothing/casual_shirts/slim-fit_shirts?category=170",
                    "http://www.mrporter.com/en-vn/mens/clothing/coats_and_jackets/bomber_jackets?category=210",
                    "http://www.mrporter.com/en-vn/mens/clothing/coats_and_jackets/denim_jackets?category=199",
                    "http://www.mrporter.com/en-vn/mens/clothing/coats_and_jackets/leather_jackets?category=198",
                    "http://www.mrporter.com/en-vn/mens/clothing/coats_and_jackets/gilets?category=207",
                    "http://www.mrporter.com/en-vn/mens/clothing/coats_and_jackets/raincoats?category=209",
                    "http://www.mrporter.com/en-vn/mens/clothing/coats_and_jackets/trench_coats?category=203",
                    "http://www.mrporter.com/en-vn/mens/clothing/coats_and_jackets/winter_coats?category=209",
                    "http://www.mrporter.com/en-vn/mens/clothing/coats_and_jackets/lightweight_jackets?category=210",
                    "http://www.mrporter.com/en-vn/mens/clothing/coats_and_jackets/field_jackets?category=210",
                    "http://www.mrporter.com/en-vn/mens/clothing/coats_and_jackets/parkas?category=205",
                    "http://www.mrporter.com/en-vn/mens/clothing/coats_and_jackets/overcoats?category=203",
                    "http://www.mrporter.com/en-vn/mens/clothing/coats_and_jackets/performance_jackets?category=210",
                    "http://www.mrporter.com/en-vn/mens/clothing/coats_and_jackets/peacoats?category=201",
                    "http://www.mrporter.com/en-vn/mens/clothing/formal_shirts/dress_shirts?category=170",
                    "http://www.mrporter.com/en-vn/mens/clothing/formal_shirts/formal_shirts?category=170",
                    "http://www.mrporter.com/en-vn/mens/clothing/formal_shirts/slim-fit_shirts?category=170",
                    "http://www.mrporter.com/en-vn/mens/clothing/jeans/straight_jeans?category=180",
                    "http://www.mrporter.com/en-vn/mens/clothing/jeans/slim_jeans?category=187",
                    "http://www.mrporter.com/en-vn/mens/clothing/jeans/selvedge_denim?category=187",
                    "http://www.mrporter.com/en-vn/mens/clothing/knitwear/cardigans?category=174",
                    "http://www.mrporter.com/en-vn/mens/clothing/knitwear/sweaters_?category=173",
                    "http://www.mrporter.com/en-vn/mens/clothing/knitwear/crew_necks?category=173",
                    "http://www.mrporter.com/en-vn/mens/clothing/knitwear/rollnecks?category=173",
                    "http://www.mrporter.com/en-vn/mens/clothing/knitwear/v-necks?category=173",
                    "http://www.mrporter.com/en-vn/mens/clothing/knitwear/zip_throughs?category=173",
                    "http://www.mrporter.com/en-vn/mens/clothing/knitwear/hooded?category=173",
                    "http://www.mrporter.com/en-vn/mens/clothing/polos/long_sleeve_polos?category=168",
                    "http://www.mrporter.com/en-vn/mens/clothing/polos/short_sleeve_polos?category=168",
                    "http://www.mrporter.com/en-vn/mens/clothing/pyjamas/pyjamas_bottoms?category=257",
                    "http://www.mrporter.com/en-vn/mens/clothing/pyjamas/pyjama_sets?category=257",
                    "http://www.mrporter.com/en-vn/mens/clothing/pyjamas/pyjama_tops?category=257",
                    "http://www.mrporter.com/en-vn/mens/clothing/pyjamas/robes?category=258",
                    "http://www.mrporter.com/en-vn/mens/clothing/shorts/casual?category=188",
                    "http://www.mrporter.com/en-vn/mens/clothing/shorts/sportswear?category=268",
                    "http://www.mrporter.com/en-vn/mens/clothing/sports/cycling?category=271",
                    "http://www.mrporter.com/en-vn/mens/clothing/sports/golf?category=271",
                    "http://www.mrporter.com/en-vn/mens/clothing/sports/running?category=271",
                    "http://www.mrporter.com/en-vn/mens/clothing/sports/sailing?category=271",
                    "http://www.mrporter.com/en-vn/mens/clothing/sports/shooting?category=271",
                    "http://www.mrporter.com/en-vn/mens/clothing/suits/suits?category=263",
                    "http://www.mrporter.com/en-vn/mens/clothing/suits/slim-fit_suits?category=263",
                    "http://www.mrporter.com/en-vn/mens/clothing/suits/suit_separates?category=263",
                    "http://www.mrporter.com/en-vn/mens/clothing/suits/morning_coats?category=263",
                    "http://www.mrporter.com/en-vn/mens/clothing/suits/morning_suits?category=263",
                    "http://www.mrporter.com/en-vn/mens/clothing/suits/waistcoats?category=263",
                    "http://www.mrporter.com/en-vn/mens/clothing/sweats/crew_necks?category=177",
                    "http://www.mrporter.com/en-vn/mens/clothing/sweats/hoodies?category=211",
                    "http://www.mrporter.com/en-vn/mens/clothing/sweats/pants?category=178",
                    "http://www.mrporter.com/en-vn/mens/clothing/sweats/zip_through?category=211",
                    "http://www.mrporter.com/en-vn/mens/clothing/swimwear/printed_swimwear?category=260",
                    "http://www.mrporter.com/en-vn/mens/clothing/swimwear/plain_swimwear?category=260",
                    "http://www.mrporter.com/en-vn/mens/clothing/swimwear/towels?category=261",
                    "http://www.mrporter.com/en-vn/mens/clothing/trousers/casual_trousers?category=190",
                    "http://www.mrporter.com/en-vn/mens/clothing/trousers/formal_trousers?category=191",
                    "http://www.mrporter.com/en-vn/mens/clothing/trousers/chinos?category=192",
                    "http://www.mrporter.com/en-vn/mens/clothing/trousers/cords?category=194",
                    "http://www.mrporter.com/en-vn/mens/clothing/trousers/slim-fit_trousers?category=178",
                    "http://www.mrporter.com/en-vn/mens/clothing/trousers/wool_trousers?category=178",
                    "http://www.mrporter.com/en-vn/mens/clothing/underwear/boxers?category=256",
                    "http://www.mrporter.com/en-vn/mens/clothing/underwear/briefs?category=255",
                    "http://www.mrporter.com/en-vn/mens/clothing/underwear/t-shirts?category=166",
                    "http://www.mrporter.com/en-vn/mens/clothing/underwear/tank_tops?category=253",
                    "http://www.mrporter.com/en-vn/mens/clothing/underwear/thermal_underwear?category=259",
                    "http://www.mrporter.com/en-vn/mens/clothing/blazers/double_breasted?category=200",
                    "http://www.mrporter.com/en-vn/mens/clothing/blazers/single_breasted?category=200",
                    "http://www.mrporter.com/en-vn/mens/clothing/blazers/waistcoats?category=200",
                    "http://www.mrporter.com/en-vn/mens/accessories/belts/leather_belts?category=247",
                    "http://www.mrporter.com/en-vn/mens/accessories/belts/fabric_belts?category=247",
                    "http://www.mrporter.com/en-vn/mens/accessories/belts/braces?category=247",
                    "http://www.mrporter.com/en-vn/mens/accessories/belts/woven_belts?category=247",
                    "http://www.mrporter.com/en-vn/mens/accessories/umbrellas/long_umbrellas?category=232",
                    "http://www.mrporter.com/en-vn/mens/accessories/umbrellas/short_umbrellas?category=232",
                    "http://www.mrporter.com/en-vn/mens/accessories/wallets/billfold_wallets?category=233",
                    "http://www.mrporter.com/en-vn/mens/accessories/wallets/cardholders?category=233",
                    "http://www.mrporter.com/en-vn/mens/accessories/wallets/money_clips?category=233",
                    "http://www.mrporter.com/en-vn/mens/accessories/wallets/zip_wallets?category=233",
                    "http://www.mrporter.com/en-vn/mens/accessories/wallets/keyrings?category=233",
                    "http://www.mrporter.com/en-vn/mens/accessories/bags/backpacks?category=223",
                    "http://www.mrporter.com/en-vn/mens/accessories/bags/briefcases?category=224",
                    "http://www.mrporter.com/en-vn/mens/accessories/bags/holdalls?category=224",
                    "http://www.mrporter.com/en-vn/mens/accessories/bags/messenger_bags?category=220",
                    "http://www.mrporter.com/en-vn/mens/accessories/bags/pouches?category=225",
                    "http://www.mrporter.com/en-vn/mens/accessories/bags/totes?category=221",
                    "http://www.mrporter.com/en-vn/mens/accessories/bags/wash_bags?category=225",
                    "http://www.mrporter.com/en-vn/mens/accessories/cufflinks_and_tie_clips/cufflinks?category=249",
                    "http://www.mrporter.com/en-vn/mens/accessories/cufflinks_and_tie_clips/lapel_pins?category=249",
                    "http://www.mrporter.com/en-vn/mens/accessories/cufflinks_and_tie_clips/tie_clips?category=249",
                    "http://www.mrporter.com/en-vn/mens/accessories/cufflinks_and_tie_clips/tie_pins?category=249",
                    "http://www.mrporter.com/en-vn/mens/accessories/hats/beanies?category=240",
                    "http://www.mrporter.com/en-vn/mens/accessories/hats/bucket_hats?category=240",
                    "http://www.mrporter.com/en-vn/mens/accessories/hats/caps?category=240",
                    "http://www.mrporter.com/en-vn/mens/accessories/hats/fedora_and_trilby?category=240",
                    "http://www.mrporter.com/en-vn/mens/accessories/hats/flat_cap?category=240",
                    "http://www.mrporter.com/en-vn/mens/accessories/jewellery/bracelets?category=228",
                    "http://www.mrporter.com/en-vn/mens/accessories/jewellery/rings?category=229",
                    "http://www.mrporter.com/en-vn/mens/accessories/ties/bow_ties?category=249",
                    "http://www.mrporter.com/en-vn/mens/accessories/ties/neck_ties?category=249",
                    "http://www.mrporter.com/en-vn/mens/accessories/ties/knitted_ties?category=249",
                    "http://www.mrporter.com/en-vn/mens/accessories/scarves/cashmere_scarves?category=243",
                    "http://www.mrporter.com/en-vn/mens/accessories/scarves/silk_scarves?category=243",
                    "http://www.mrporter.com/en-vn/mens/accessories/scarves/wool_scarves?category=243",
                    "http://www.mrporter.com/en-vn/mens/accessories/scarves/cotton_scarves?category=243",
                    "http://www.mrporter.com/en-vn/mens/accessories/scarves/printed_scarves?category=243",
                    "http://www.mrporter.com/en-vn/mens/accessories/scarves/plain_scarves?category=243",
                    "http://www.mrporter.com/en-vn/mens/accessories/pens_and_stationery/pens?category=235",
                    "http://www.mrporter.com/en-vn/mens/accessories/pens_and_stationery/notebooks?category=235",
                    "http://www.mrporter.com/en-vn/mens/accessories/socks/casual_socks?category=246",
                    "http://www.mrporter.com/en-vn/mens/accessories/socks/formal_socks?category=246",
                    "http://www.mrporter.com/en-vn/mens/accessories/socks/plain_socks?category=246",
                    "http://www.mrporter.com/en-vn/mens/accessories/socks/patterned_socks?category=246",
                    "http://www.mrporter.com/en-vn/mens/shoes/boots/biker_boots?category=215",
                    "http://www.mrporter.com/en-vn/mens/shoes/boots/chelsea_boots?category=215",
                    "http://www.mrporter.com/en-vn/mens/shoes/boots/desert_boots?category=215",
                    "http://www.mrporter.com/en-vn/mens/shoes/boots/lace-up_boots?category=215",
                    "http://www.mrporter.com/en-vn/mens/shoes/boots/wellington_boots?category=215",
                    "http://www.mrporter.com/en-vn/mens/shoes/sneakers/high_top_sneakers?category=213",
                    "http://www.mrporter.com/en-vn/mens/shoes/sneakers/low_top_sneakers?category=213"]
          list_cate.each do |link|
            FashionCrawler::Models::Resource.create({
              url: link.to_s,
              task: 'MrporterProcessAtCatePage',
              is_visited: false,
              site_name: 'Mrporter',
              store: FashionCrawler::Models::Store.find_by(name: 'Mrporter')
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


    class MrporterProcessAtCatePage
      def self.execute(url, body)
        doc = Nokogiri::HTML(body)
        begin
          category = url.scan(/category=(\d+)/).join("")
            doc.xpath("//div[@id='product-list']//a").each do |link|
               if link["href"].present? && link["href"].match(/\/\d+$/)
                  detail_url = "http://www.mrporter.com" + link["href"] + "?category=#{category}"
                  unless FashionCrawler::Models::Resource.where(url: detail_url).exists?
                    #puts "!!!!!!!!!!!!#{detail_url}!!!!!!!!!!"
                    FashionCrawler::Models::Resource.create({
                    url: detail_url,
                    task: 'MrporterProcessAtDetailPage',
                    is_visited: false,
                    site_name: 'Mrporter',
                    store: FashionCrawler::Models::Store.find_by(name: 'Mrporter')
                    })
                  end
               end
            end
            doc.xpath("//a").each do |link|
              if link.text.match(/Next/) && link["href"].present? && link["href"].match(/pn=\d+/)
                next_url = "http://www.mrporter.com" + link["href"] + "&category=#{category}"
                unless FashionCrawler::Models::Resource.where(url: next_url).exists?
                    #puts "----------------------#{next_url}-----------------------------"
                    FashionCrawler::Models::Resource.create({
                    url: next_url,
                    task: 'MrporterProcessAtCatePage',
                    is_visited: false,
                    site_name: 'Mrporter',
                    store: FashionCrawler::Models::Store.find_by(name: 'Mrporter')
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

    class MrporterProcessAtDetailPage
      def self.execute(url, body)
        doc = Nokogiri::HTML(body)
        begin
          url2 = url.gsub(/category=(.)*/, "").gsub(/\?/, "").gsub(/\&/, "")
          product = FashionCrawler::Models::Item.where(link: url2).first
          if product.nil?

            item = FashionCrawler::Models::Item.new
            item.link = url2

            brand_node = doc.at_xpath("//div[@id='product-details']//h1")
            brand_name = brand_node.text.strip if brand_node.present?

            name = doc.at_xpath("//div[@id='product-details']//h4")
            item.name = name.text.gsub(brand_name, "").strip unless name.nil?

            unless brand_name.nil?
              master_brand = MasterBrand.by_brand_name(brand_name)
              unless master_brand.nil?
                item.brand_id = master_brand.brand_id
                item.brand_name = MasterBrand.id_is_other?(item.brand_id) ? brand_name : master_brand.brand_name
                item.brand_name_ja = master_brand.brand_name_ja
              end
            end

            item.site_id = 24
            item.site_name = "Mrporter"
          else
            item = product
          end

          description = doc.at_xpath("//div[@class='productContentPiece']")
          item.description = description.text.strip if description.present?

          original_price = doc.at_xpath("//span[@class='price-value']")

          if original_price.present?
            item.original_price = original_price.try(:text).try(:strip)
          end

          images = []
          doc.xpath("//div[@id='product-carousel']//li//img").each do |img|
            img["src"] = img["src"].gsub(/http\:\/\//, "") if img["src"].include?("http://")
            images << "http://" + img["src"].to_s.gsub(/xs.jpg/, "l.jpg").gsub(/\/\/cache/,"cache")
          end
          item.images = images.join(",")

          category = url.scan(/category=(\d+)/).join('')
          item.category_id = category
          master_category = MasterCategory.by_category_3_id(category.to_i)
          unless master_category.nil?
            item.category_name = master_category.category_3
            general_category_id = master_category.general_category_id
          end

          sizes = []
          number_of_products = 0
          doc.xpath("//select[@id='select-size']//option").each do |option|
            sizes << option.text.gsub(/- Sold Out/,"").gsub(/-  Only one left/, "").strip unless option.text.match(/Select size/)
            if option.text.match(/Only one left/)
              number_of_products = number_of_products + 1
            elsif !option.text.match(/Sold Out/)
              number_of_products = number_of_products + 3
            end
          end
          sizes = sizes.join(',')

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
          else
             item.flag = 0
          end

           if item.name.present?  && category.to_i > 0 && item.flag == 1
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
