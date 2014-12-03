# encoding: utf-8
require 'nokogiri'
require 'unicode'
require 'uri'
require 'date'
require 'open-uri'

module FashionCrawler
  module Tasks
    class MatchesfashionProcessAtMainPage
      def self.execute(url, body)
        doc = Nokogiri::HTML(body)
        begin
          ["http://www.matchesfashion.com/mens/outerwear/parka?showproducts=true&category=205",
            "http://www.matchesfashion.com/mens/shop/blazers/casual?showproducts=true&category=200",
            "http://www.matchesfashion.com/mens/shop/blazers/formal?showproducts=true&category=200",
            "http://www.matchesfashion.com/mens/bags/backpack?showproducts=true&category=223",
            "http://www.matchesfashion.com/mens/bags/briefcase?showproducts=true&category=224",
            "http://www.matchesfashion.com/mens/bags/hand-held?showproducts=true&category=225",
            "http://www.matchesfashion.com/mens/bags/holdall?showproducts=true&category=221",
            "http://www.matchesfashion.com/mens/bags/luggage?showproducts=true&category=226",
            "http://www.matchesfashion.com/mens/bags/messenger?showproducts=true&category=220",
            "http://www.matchesfashion.com/mens/bags/tech?showproducts=true&category=226",
            "http://www.matchesfashion.com/mens/bags/tote?showproducts=true&category=221",
            "http://www.matchesfashion.com/mens/beachwear/beach-sandals?showproducts=true&category=212",
            "http://www.matchesfashion.com/mens/beachwear/beach-t-shirts?showproducts=true&category=166",
            "http://www.matchesfashion.com/mens/beachwear/swim-shorts?showproducts=true&category=260",
            "http://www.matchesfashion.com/mens/outerwear/bomber?showproducts=true&category=209",
            "http://www.matchesfashion.com/mens/outerwear/casual?showproducts=true&category=197",
            "http://www.matchesfashion.com/mens/outerwear/down?showproducts=true&category=209",
            "http://www.matchesfashion.com/mens/outerwear/gilet?showproducts=true&category=209",
            "http://www.matchesfashion.com/mens/outerwear/leather?showproducts=true&category=198",
            "http://www.matchesfashion.com/mens/outerwear/overcoat?showproducts=true&category=203",
            "http://www.matchesfashion.com/mens/outerwear/raincoat?showproducts=true&category=203",
            "http://www.matchesfashion.com/mens/accessories/belts?showproducts=true&category=247",
            "http://www.matchesfashion.com/mens/accessories/gloves?showproducts=true&category=244",
            "http://www.matchesfashion.com/mens/accessories/hats?showproducts=true&category=240",
            "http://www.matchesfashion.com/mens/accessories/jewellery?showproducts=true&category=230",
            "http://www.matchesfashion.com/mens/accessories/scarves?showproducts=true&category=243",
            "http://www.matchesfashion.com/mens/accessories/small-accessories?showproducts=true&category=252",
            "http://www.matchesfashion.com/mens/accessories/socks?showproducts=true&category=246",
            "http://www.matchesfashion.com/mens/accessories/sunglasses?showproducts=true&category=237",
            "http://www.matchesfashion.com/mens/accessories/technology?showproducts=true&category=251",
            "http://www.matchesfashion.com/mens/accessories/ties?showproducts=true&category=249",
            "http://www.matchesfashion.com/mens/accessories/underwear?showproducts=true&category=259",
            "http://www.matchesfashion.com/mens/accessories/wallets?showproducts=true&category=233",
            "http://www.matchesfashion.com/mens/jeans/skinny?showproducts=true&category=182",
            "http://www.matchesfashion.com/mens/jeans/slim?showproducts=true&category=187",
            "http://www.matchesfashion.com/mens/jeans/straight?showproducts=true&category=180",
            "http://www.matchesfashion.com/mens/knitwear/cardigan?showproducts=true&category=174",
            "http://www.matchesfashion.com/mens/knitwear/crew-neck?showproducts=true&category=173",
            "http://www.matchesfashion.com/mens/knitwear/roll-neck?showproducts=true&category=173",
            "http://www.matchesfashion.com/mens/knitwear/v-neck?showproducts=true&category=173",
            "http://www.matchesfashion.com/mens/knitwear/zip-up?showproducts=true&category=173",
            "http://www.matchesfashion.com/mens/shirts/casual?showproducts=true&category=170",
            "http://www.matchesfashion.com/mens/shirts/fashion?showproducts=true&category=170",
            "http://www.matchesfashion.com/mens/shirts/short-sleeve?showproducts=true&category=170",
            "http://www.matchesfashion.com/mens/shirts/tie-shirts?showproducts=true&category=170",
            "http://www.matchesfashion.com/mens/shirts/tuxedo?showproducts=true&category=170",
            "http://www.matchesfashion.com/mens/shoes/boots?showproducts=true&category=215",
            "http://www.matchesfashion.com/mens/shoes/brogues?showproducts=true&category=214",
            "http://www.matchesfashion.com/mens/shoes/derbies?showproducts=true&category=214",
            "http://www.matchesfashion.com/mens/shoes/driving-shoes?showproducts=true&category=216",
            "http://www.matchesfashion.com/mens/shoes/espadrilles?showproducts=true&category=363",
            "http://www.matchesfashion.com/mens/shoes/lace-ups?showproducts=true&category=214",
            "http://www.matchesfashion.com/mens/shoes/loafers?showproducts=true&category=216",
            "http://www.matchesfashion.com/mens/shoes/monks?showproducts=true&category=214",
            "http://www.matchesfashion.com/mens/shoes/sandals?showproducts=true&category=212",
            "http://www.matchesfashion.com/mens/shoes/trainers?showproducts=true&category=172",
            "http://www.matchesfashion.com/mens/shorts/casual?showproducts=true&category=188",
            "http://www.matchesfashion.com/mens/shorts/tailored?showproducts=true&category=188",
            "http://www.matchesfashion.com/mens/suits/dinner?showproducts=true&category=263",
            "http://www.matchesfashion.com/mens/suits/formal?showproducts=true&category=263",
            "http://www.matchesfashion.com/womens/coats/capes?showproducts=true&category=56",
            "http://www.matchesfashion.com/womens/coats/day?showproducts=true&category=40",
            "http://www.matchesfashion.com/womens/coats/down?showproducts=true&category=57",
            "http://www.matchesfashion.com/womens/coats/evening?showproducts=true&category=40",
            "http://www.matchesfashion.com/womens/coats/leather-and-shearling?showproducts=true&category=345",
            "http://www.matchesfashion.com/womens/coats/parkas?showproducts=true&category=45",
            "http://www.matchesfashion.com/womens/coats/trench-coats?showproducts=true&category=43",
            "http://www.matchesfashion.com/womens/coats/fur?showproducts=true&category=42",
            "http://www.matchesfashion.com/womens/bags/backpacks?showproducts=true&category=84",
            "http://www.matchesfashion.com/womens/bags/beach-bags?showproducts=true&category=85",
            "http://www.matchesfashion.com/womens/bags/clutch-bags?showproducts=true&category=81",
            "http://www.matchesfashion.com/womens/bags/shoulder-bags?showproducts=true&category=82",
            "http://www.matchesfashion.com/womens/bags/tote-bags?showproducts=true&category=77",
            "http://www.matchesfashion.com/womens/bags/travel-bags?showproducts=true&category=349",
            "http://www.matchesfashion.com/womens/accessories/belts?showproducts=true&category=109",
            "http://www.matchesfashion.com/womens/accessories/gloves?showproducts=true&category=108",
            "http://www.matchesfashion.com/womens/accessories/hats?showproducts=true&category=103",
            "http://www.matchesfashion.com/womens/accessories/scarves?showproducts=true&category=105",
            "http://www.matchesfashion.com/womens/accessories/small-accessories?showproducts=true&category=97",
            "http://www.matchesfashion.com/womens/accessories/sunglasses?showproducts=true&category=100",
            "http://www.matchesfashion.com/womens/accessories/technology?showproducts=true&category=111",
            "http://www.matchesfashion.com/womens/accessories/travel?showproducts=true&category=349",
            "http://www.matchesfashion.com/womens/accessories/wallets?showproducts=true&category=86",
            "http://www.matchesfashion.com/womens/accessories/wash-bags?showproducts=true&category=85",
            "http://www.matchesfashion.com/womens/accessories/watches?showproducts=true&category=98",
            "http://www.matchesfashion.com/womens/activewear/bottoms?showproducts=true&category=161",
            "http://www.matchesfashion.com/womens/activewear/dresses?showproducts=true&category=169",
            "http://www.matchesfashion.com/womens/activewear/shoes?showproducts=true&category=67",
            "http://www.matchesfashion.com/womens/activewear/skiwear?showproducts=true&category=165",
            "http://www.matchesfashion.com/womens/activewear/swimwear?showproducts=true&category=132",
            "http://www.matchesfashion.com/womens/activewear/tops?showproducts=true&category=158",
            "http://www.matchesfashion.com/womens/beachwear/beach-dress?showproducts=true&category=132",
            "http://www.matchesfashion.com/womens/beachwear/bikinis?showproducts=true&category=132",
            "http://www.matchesfashion.com/womens/beachwear/cover-ups?showproducts=true&category=132",
            "http://www.matchesfashion.com/womens/beachwear/kaftans?showproducts=true&category=133",
            "http://www.matchesfashion.com/womens/beachwear/one-piece?showproducts=true&category=36",
            "http://www.matchesfashion.com/womens/hosiery/socks?showproducts=true&category=116",
            "http://www.matchesfashion.com/womens/hosiery/tights?showproducts=true&category=114",
            "http://www.matchesfashion.com/womens/dresses/beach-dress?showproducts=true&category=144",
            "http://www.matchesfashion.com/womens/dresses/cocktail?showproducts=true&category=143",
            "http://www.matchesfashion.com/womens/dresses/day?showproducts=true&category=144",
            "http://www.matchesfashion.com/womens/dresses/long-sleeved?showproducts=true&category=3",
            "http://www.matchesfashion.com/womens/dresses/maxis?showproducts=true&category=146",
            "http://www.matchesfashion.com/womens/dresses/midi?showproducts=true&category=147",
            "http://www.matchesfashion.com/womens/dresses/minis?showproducts=true&category=148",
            "http://www.matchesfashion.com/womens/dresses/printed?showproducts=true&category=153",
            "http://www.matchesfashion.com/womens/dresses/red-carpet?showproducts=true&category=145",
            "http://www.matchesfashion.com/womens/dresses/sweater?showproducts=true&category=153",
            "http://www.matchesfashion.com/womens/dresses/work?showproducts=true&category=145",
            "http://www.matchesfashion.com/womens/fine-jewellery/bracelets?showproducts=true&category=93",
            "http://www.matchesfashion.com/womens/fine-jewellery/earrings?showproducts=true&category=91",
            "http://www.matchesfashion.com/womens/fine-jewellery/necklaces?showproducts=true&category=90",
            "http://www.matchesfashion.com/womens/fine-jewellery/rings?showproducts=true&category=92",
            "http://www.matchesfashion.com/womens/jackets/biker?showproducts=true&category=47",
            "http://www.matchesfashion.com/womens/jackets/blazer?showproducts=true&category=52",
            "http://www.matchesfashion.com/womens/jackets/bomber?showproducts=true&category=47",
            "http://www.matchesfashion.com/womens/jackets/casual?showproducts=true&category=47",
            "http://www.matchesfashion.com/womens/jackets/denim?showproducts=true&category=47",
            "http://www.matchesfashion.com/womens/jackets/gilet?showproducts=true&category=47",
            "http://www.matchesfashion.com/womens/jackets/leather-and-shearling?showproducts=true&category=47",
            "http://www.matchesfashion.com/womens/jackets/occasion?showproducts=true&category=47",
            "http://www.matchesfashion.com/womens/jackets/fur?showproducts=true&category=47",
            "http://www.matchesfashion.com/womens/jewellery/bracelets?showproducts=true&category=93",
            "http://www.matchesfashion.com/womens/jewellery/cuffs?showproducts=true&category=93",
            "http://www.matchesfashion.com/womens/jewellery/earrings?showproducts=true&category=91",
            "http://www.matchesfashion.com/womens/jewellery/necklaces?showproducts=true&category=90",
            "http://www.matchesfashion.com/womens/jewellery/rings?showproducts=true&category=92",
            "http://www.matchesfashion.com/womens/jeans/boyfriend?showproducts=true&category=339",
            "http://www.matchesfashion.com/womens/jeans/colour?showproducts=true&category=28",
            "http://www.matchesfashion.com/womens/jeans/cropped?showproducts=true&category=22",
            "http://www.matchesfashion.com/womens/jeans/distressed?showproducts=true&category=24",
            "http://www.matchesfashion.com/womens/jeans/flared?showproducts=true&category=25",
            "http://www.matchesfashion.com/womens/jeans/high-rise?showproducts=true&category=28",
            "http://www.matchesfashion.com/womens/jeans/low-rise?showproducts=true&category=28",
            "http://www.matchesfashion.com/womens/jeans/mid-rise?showproducts=true&category=28",
            "http://www.matchesfashion.com/womens/jeans/print?showproducts=true&category=28",
            "http://www.matchesfashion.com/womens/jeans/skinny-leg?showproducts=true&category=26",
            "http://www.matchesfashion.com/womens/jeans/straight-leg?showproducts=true&category=23",
            "http://www.matchesfashion.com/womens/knitwear/cardigans?showproducts=true&category=7",
            "http://www.matchesfashion.com/womens/knitwear/roll-necks?showproducts=true&category=6",
            "http://www.matchesfashion.com/womens/knitwear/sweaters?showproducts=true&category=6"
            ].each do |link|
                FashionCrawler::Models::Resource.create({
                  url: link,
                  task: "MatchesfashionProcessAtCategory",
                  is_visited: false,
                  site_name: 'Matchesfashion',
                  store: FashionCrawler::Models::Store.find_by(name: 'Matchesfashion')
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


    class MatchesfashionProcessAtCategory
      def self.execute(url, body)
        doc = Nokogiri::HTML(body)
        begin
          category = url.scan(/category=(\d+)/).join("")
          doc.xpath("//div[@class='products']//a").each do |link|
            if link["href"].present? && link["href"].match(/\/product\/\d+/)
              detail_url = "http://www.matchesfashion.com" + link["href"] + "?category=#{category}"
              unless FashionCrawler::Models::Resource.where(url: detail_url).exists?
                # puts "!!!!!!!!!!!!#{detail_url}!!!!!!!!!!"
                FashionCrawler::Models::Resource.create({
                url: detail_url,
                task: 'MatchesfashionProcessAtDetailPage',
                is_visited: false,
                site_name: 'Matchesfashion',
                store: FashionCrawler::Models::Store.find_by(name: 'Matchesfashion')
                })
              end
            end
            doc.xpath("//a").each do |link|
              if link.text.match(/Next/)
                next_url = "http://www.matchesfashion.com" + link["href"] + "&category=#{category}"
                unless FashionCrawler::Models::Resource.where(url: next_url).exists?
                  FashionCrawler::Models::Resource.create({
                  url: next_url,
                  task: 'MatchesfashionProcessAtCategory',
                  is_visited: false,
                  site_name: 'Matchesfashion',
                  store: FashionCrawler::Models::Store.find_by(name: 'Matchesfashion')
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

    class MatchesfashionProcessAtDetailPage
      def self.execute(url, body)
        doc = Nokogiri::HTML(body)
        begin
          url2 = url.gsub(/category=(.)*/, "").gsub(/\?/, "").gsub(/\&/, "")
          product = FashionCrawler::Models::Item.where(link: url2).first
          if product.nil?

            item = FashionCrawler::Models::Item.new
            item.link = url2

            brand_node = doc.at_xpath("//div[@class='info']//h2[@class='designer']")
            brand_name = brand_node.try(:text).try(:strip)

            name = doc.at_xpath("//div[@class='info']//h3[@class='description']")
            item.name = name.text.strip if name.present?

            unless brand_name.nil?
              master_brand = MasterBrand.by_brand_name(brand_name)
              unless master_brand.nil?
                item.brand_id = master_brand.brand_id
                item.brand_name = MasterBrand.id_is_other?(item.brand_id) ? brand_name : master_brand.brand_name
                item.brand_name_ja = master_brand.brand_name_ja
              end
            end

            item.site_id = 25
            item.site_name = "Matchesfashion"
          else
            item = product
          end

          description = doc.xpath("//div[@class='panel']/div[@class='scroll']//p")
          item.description = description.try(:text).gsub(/Size Guide/, "").try(:strip)

          doc.xpath("//div[@class='info']").each do |info|
            info = Nokogiri::HTML(info.inner_html)
            name_info = info.at_xpath("//h3")
            if name_info.present?
              name = name_info.text.strip
              if name == item.name.to_s
                price = info.at_xpath("//div[@class='price']")
                item.original_price = price.try(:text).try(:strip)
                break
              end
            end
          end
          item.name = item.name.to_s.gsub(/\(\d+\)/, '')

          images = []
          doc.xpath("//div[@class='images']//div[@class='image-list']//img").each do |img|
            images << img["src"]
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
          list = doc.at_xpath("//div[@class='controls add-basket visible-wishlist-add']//select[@class='size']")
          if list.present?
            Nokogiri::HTML(list.inner_html).xpath("//option").each do |option|
              unless option.text.match(/Sold Out/) || option.text.match(/SELECT SIZE/)
                sizes << option.text.strip
              end
            end
          end
          number_of_products = sizes.uniq.count
          sizes = sizes.uniq.join(',')

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

          if item.name.present?  && category.to_i > 0 && item.original_price && item.flag == 1
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
