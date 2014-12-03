# encoding: utf-8
require 'nokogiri'
require 'unicode'
require 'uri'
require 'date'
require 'open-uri'

module FashionCrawler
  module Tasks
    class CogglesProcessAtMainPage
      def self.execute(url, body)
        begin
          list_cate = ["http://www.coggles.com/woman/category/trousers.list#en_clothingStyle_content:Trousers?category=35",
        "http://www.coggles.com/woman/category/sweatshirts.list#en_clothingStyle_content:Sweatshirts?category=10",
        "http://www.coggles.com/woman/category/sweatshirts.list#en_clothingStyle_content:Jumpers?category=46",
        "http://www.coggles.com/woman/category/sweatshirts.list#en_clothingStyle_content:Hoodies?category=8",
        "http://www.coggles.com/woman/category/swimwear.list#en_clothingStyle_content:Tunics?category=5",
        "http://www.coggles.com/woman/category/swimwear.list#en_clothingStyle_content:Swimsuits?category=132",
        "http://www.coggles.com/woman/category/swimwear.list#en_clothingStyle_content:Maxi Dresses?category=133",
        "http://www.coggles.com/woman/category/swimwear.list#en_clothingStyle_content:Bikinis?category=132",
        "http://www.coggles.com/woman/category/swimwear.list#en_clothingStyle_content:Beachwear?category=132",
        "http://www.coggles.com/woman/category/jackets.list#en_clothingStyle_content:Raincoats?category=47",
        "http://www.coggles.com/woman/category/jackets.list#en_clothingStyle_content:Quilted Jackets?category=47",
        "http://www.coggles.com/woman/category/jackets.list#en_clothingStyle_content:Parkas and Macs?category=47",
        "http://www.coggles.com/woman/category/jackets.list#en_clothingStyle_content:Lightweight Jackets?category=47",
        "http://www.coggles.com/woman/category/jackets.list#en_clothingStyle_content:Leather Jackets?category=50",
        "http://www.coggles.com/woman/category/jackets.list#en_clothingStyle_content:Gilets?category=47",
        "http://www.coggles.com/woman/category/jackets.list#en_clothingStyle_content:Denim Jackets?category=51",
        "http://www.coggles.com/woman/category/jackets.list#en_clothingStyle_content:Coats?category=47",
        "http://www.coggles.com/woman/category/jackets.list#en_clothingStyle_content:Casual Jackets?category=49",
        "http://www.coggles.com/woman/category/jackets.list#en_clothingStyle_content:Capes?category=47",
        "http://www.coggles.com/woman/category/jackets.list#en_clothingStyle_content:Blazers?category=48",
        "http://www.coggles.com/woman/category/jackets.list#en_clothingStyle_content:Biker and Bomber Jackets?category=47",
        "http://www.coggles.com/woman/category/vests.list#en_clothingStyle_content:Camis and Vest Tops?category=13",
        "http://www.coggles.com/woman/category/jewellery.list#en_brand_content:Venessa Arizaga?category=97",
        "http://www.coggles.com/woman/category/jewellery.list#en_brand_content:Tatty Devine?category=97",
        "http://www.coggles.com/woman/category/jewellery.list#en_brand_content:Nocturne?category=97",
        "http://www.coggles.com/woman/category/jewellery.list#en_brand_content:Matthew Williamson?category=97",
        "http://www.coggles.com/woman/category/jewellery.list#en_brand_content:Maria Francesca Pepe?category=97",
        "http://www.coggles.com/woman/category/jewellery.list#en_brand_content:Marc by Marc Jacobs?category=97",
        "http://www.coggles.com/woman/category/jewellery.list#en_brand_content:Lara Bohinc?category=97",
        "http://www.coggles.com/woman/category/jewellery.list#en_brand_content:Katie Rowland?category=97",
        "http://www.coggles.com/woman/category/jewellery.list#en_brand_content:Daisy Knights?category=97",
        "http://www.coggles.com/woman/category/jewellery.list#en_brand_content:Astley Clarke?category=97",
        "http://www.coggles.com/woman/category/jeans.list#en_jeanFit_content:Tapered Fit?category=340",
        "http://www.coggles.com/woman/category/jeans.list#en_jeanFit_content:Straight Fit?category=23",
        "http://www.coggles.com/woman/category/jeans.list#en_jeanFit_content:Slim Fit?category=28",
        "http://www.coggles.com/woman/category/jeans.list#en_jeanFit_content:Skinny Fit?category=26",
        "http://www.coggles.com/woman/category/jeans.list#en_jeanFit_content:Boyfriend Fit?category=339",
        "http://www.coggles.com/woman/category/knitwear.list#en_clothingStyle_content:T-Shirts?category=2",
        "http://www.coggles.com/woman/category/knitwear.list#en_clothingStyle_content:Skater Dresses?category=6",
        "http://www.coggles.com/woman/category/knitwear.list#en_clothingStyle_content:Shirts and Blouses?category=10",
        "http://www.coggles.com/woman/category/knitwear.list#en_clothingStyle_content:Midi Dresses?category=6",
        "http://www.coggles.com/woman/category/knitwear.list#en_clothingStyle_content:Jumpsuits?category=154",
        "http://www.coggles.com/woman/category/knitwear.list#en_clothingStyle_content:Jumpers?category=46",
        "http://www.coggles.com/woman/category/knitwear.list#en_clothingStyle_content:Jumper Dresses?category=46",
        "http://www.coggles.com/woman/category/knitwear.list#en_clothingStyle_content:Cardigans?category=7",
        "http://www.coggles.com/woman/category/jumpsuits.list#en_clothingStyle_content:Playsuits?category=154",
        "http://www.coggles.com/woman/category/jumpsuits.list#en_clothingStyle_content:Jumpsuits?category=154",
        "http://www.coggles.com/woman/category/shirts.list#en_clothingStyle_content:Shirts and Blouses?category=10",
        "http://www.coggles.com/woman/category/shorts.list#en_clothingStyle_content:Smart Shorts?category=18",
        "http://www.coggles.com/woman/category/shorts.list#en_clothingStyle_content:High Waisted Shorts?category=18",
        "http://www.coggles.com/woman/category/shorts.list#en_clothingStyle_content:Denim Shorts?category=338",
        "http://www.coggles.com/woman/category/shorts.list#en_clothingStyle_content:Casual Shorts?category=18",
        "http://www.coggles.com/woman/category/skirts.list#en_clothingStyle_content:Skater Skirts?category=337",
        "http://www.coggles.com/woman/category/skirts.list#en_clothingStyle_content:Pencil Skirts?category=15",
        "http://www.coggles.com/woman/category/skirts.list#en_clothingStyle_content:Mini Skirts?category=16",
        "http://www.coggles.com/woman/category/skirts.list#en_clothingStyle_content:Midi Skirts?category=15",
        "http://www.coggles.com/woman/category/skirts.list#en_clothingStyle_content:Maxi Skirts?category=15",
        "http://www.coggles.com/woman/category/skirts.list#en_clothingStyle_content:Maxi Dresses?category=15",
        "http://www.coggles.com/woman/category/skirts.list#en_clothingStyle_content:High Waisted Skirts?category=336",
        "http://www.coggles.com/woman/category/t-shirts-and-tops.list#en_clothingStyle_content:Tunics?category=5",
        "http://www.coggles.com/woman/category/t-shirts-and-tops.list#en_clothingStyle_content:T-Shirts?category=2",
        "http://www.coggles.com/woman/category/t-shirts-and-tops.list#en_clothingStyle_content:Shirts and Blouses?category=10",
        "http://www.coggles.com/woman/category/t-shirts-and-tops.list#en_clothingStyle_content:Polo-Shirts?category=11",
        "http://www.coggles.com/woman/category/t-shirts-and-tops.list#en_clothingStyle_content:Maxi Dresses?category=2",
        "http://www.coggles.com/woman/category/t-shirts-and-tops.list#en_clothingStyle_content:Long Sleeved Tops?category=3",
        "http://www.coggles.com/woman/category/t-shirts-and-tops.list#en_clothingStyle_content:Hoodies?category=14",
        "http://www.coggles.com/woman/category/t-shirts-and-tops.list#en_clothingStyle_content:Going Out Tops?category=14",
        "http://www.coggles.com/woman/category/t-shirts-and-tops.list#en_clothingStyle_content:Cropped Tops?category=14",
        "http://www.coggles.com/woman/category/t-shirts-and-tops.list#en_clothingStyle_content:Camis and Vest Tops?category=13",
        "http://www.coggles.com/woman/category/t-shirts-and-tops.list#en_clothingStyle_content:Bralets?category=14",
        "http://www.coggles.com/woman/category/t-shirts-and-tops.list#en_clothingStyle_content:Bodies?category=14",
        "http://www.coggles.com/woman/category/t-shirts-and-tops.list#en_clothingStyle_content:Beachwear?category=14",
        "http://www.coggles.com/woman/category/accessories.list#en_Accessorytype_content:Phone Case?category=111",
        "http://www.coggles.com/woman/category/accessories.list#en_Accessorytype_content:Keyring?category=112",
        "http://www.coggles.com/woman/category/accessories.list#en_Accessorytype_content:Jewellery?category=97",
        "http://www.coggles.com/woman/category/accessories.list#en_Accessorytype_content:iPad and Tablet Cases?category=111",
        "http://www.coggles.com/woman/category/accessories.list#en_Accessorytype_content:Hat?category=103",
        "http://www.coggles.com/woman/category/accessories.list#en_Accessorytype_content:Hair Accessories?category=96",
        "http://www.coggles.com/woman/category/accessories.list#en_Accessorytype_content:Gloves?category=108",
        "http://www.coggles.com/woman/category/accessories.list#en_Accessorytype_content:Belt?category=109",
        "http://www.coggles.com/woman/category/dresses.list#en_clothingStyle_content:Tunic Dresses?category=5",
        "http://www.coggles.com/woman/category/dresses.list#en_clothingStyle_content:T-Shirt Dresses?category=153",
        "http://www.coggles.com/woman/category/dresses.list#en_clothingStyle_content:Sun Dresses?category=153",
        "http://www.coggles.com/woman/category/dresses.list#en_clothingStyle_content:Smock Dresses?category=153",
        "http://www.coggles.com/woman/category/dresses.list#en_clothingStyle_content:Skater Dresses?category=153",
        "http://www.coggles.com/woman/category/dresses.list#en_clothingStyle_content:Shirt Dresses?category=153",
        "http://www.coggles.com/woman/category/dresses.list#en_clothingStyle_content:Shift Dresses?category=153",
        "http://www.coggles.com/woman/category/dresses.list#en_clothingStyle_content:Mini Dresses?category=148",
        "http://www.coggles.com/woman/category/dresses.list#en_clothingStyle_content:Midi Dresses?category=147",
        "http://www.coggles.com/woman/category/dresses.list#en_clothingStyle_content:Maxi Dresses?category=146",
        "http://www.coggles.com/woman/category/bags.list#en_Accessorytype_content:Bag?category=85",
        "http://www.coggles.com/woman/category/dresses.list#en_clothingStyle_content:Jumper Dresses?category=153",
        "http://www.coggles.com/woman/category/dresses.list#en_clothingStyle_content:Going Out Dresses?category=153",
        "http://www.coggles.com/woman/category/dresses.list#en_clothingStyle_content:Bodycon Dresses?category=153",
        "http://www.coggles.com/woman/category/dresses.list#en_clothingStyle_content:Beachwear?category=153",
        "http://www.coggles.com/woman/category/accessories.list#en_Accessorytype_content:Watch?category=98",
        "http://www.coggles.com/woman/category/footwear.list#en_FootwearType_content:Boots?category=76",
        "http://www.coggles.com/woman/category/accessories.list#en_Accessorytype_content:Wallet?category=86",
        "http://www.coggles.com/woman/category/accessories.list#en_Accessorytype_content:Umbrella?category=110",
        "http://www.coggles.com/woman/category/accessories.list#en_Accessorytype_content:Sunglasses?category=100",
        "http://www.coggles.com/woman/category/accessories.list#en_Accessorytype_content:Scarf?category=105",
        "http://www.coggles.com/woman/category/footwear.list#en_FootwearType_content:Trainers?category=9",
        "http://www.coggles.com/woman/category/footwear.list#en_FootwearType_content:Wellington Boots?category=75",
        "http://www.coggles.com/woman/category/footwear.list#en_FootwearType_content:Wedges?category=63",
        "http://www.coggles.com/woman/category/footwear.list#en_FootwearType_content:Shoes?category=67",
        "http://www.coggles.com/woman/category/accessories.list#en_Accessorytype_content:Purse?category=85",
        "http://www.coggles.com/woman/category/footwear.list#en_FootwearType_content:High Heels?category=62",
        "http://www.coggles.com/woman/category/footwear.list#en_FootwearType_content:Sandals?category=58",
        "http://www.coggles.com/woman/category/footwear.list#en_FootwearType_content:Flats?category=76",
        "http://www.coggles.com/man/category/knitwear.list#en_clothingStyle_content:Cardigans?category=174",
        "http://www.coggles.com/man/category/knitwear.list#en_clothingStyle_content:Jumpers?category=173",
        "http://www.coggles.com/man/category/jeans.list#en_jeanFit_content:Anti Fit?category=187",
        "http://www.coggles.com/man/category/jeans.list#en_jeanFit_content:Drop Crotch?category=187",
        "http://www.coggles.com/man/category/jeans.list#en_jeanFit_content:Regular Fit?category=187",
        "http://www.coggles.com/man/category/jeans.list#en_jeanFit_content:Skinny Fit?category=182",
        "http://www.coggles.com/man/category/jeans.list#en_jeanFit_content:Slim Fit?category=187",
        "http://www.coggles.com/man/category/jeans.list#en_jeanFit_content:Straight Fit?category=180",
        "http://www.coggles.com/man/category/jeans.list#en_jeanFit_content:Tapered Fit?category=184",
        "http://www.coggles.com/man/category/footwear.list#en_FootwearType_content:Boots?category=215",
        "http://www.coggles.com/man/category/footwear.list#en_FootwearType_content:Sandals?category=212",
        "http://www.coggles.com/man/category/footwear.list#en_FootwearType_content:Shoes?category=218",
        "http://www.coggles.com/man/category/footwear.list#en_FootwearType_content:Trainers?category=172",
        "http://www.coggles.com/man/category/footwear.list#en_FootwearType_content:Wellington Boots?category=215",
        "http://www.coggles.com/man/category/jackets.list#en_clothingStyle_content:Biker and Bomber Jackets?category=360",
        "http://www.coggles.com/man/category/jackets.list#en_clothingStyle_content:Blazers?category=200",
        "http://www.coggles.com/man/category/jackets.list#en_clothingStyle_content:Casual Jackets?category=197",
        "http://www.coggles.com/man/category/jackets.list#en_clothingStyle_content:Coats?category=209",
        "http://www.coggles.com/man/category/jackets.list#en_clothingStyle_content:Denim Jackets?category=199",
        "http://www.coggles.com/man/category/jackets.list#en_clothingStyle_content:Gilets?category=210",
        "http://www.coggles.com/man/category/jackets.list#en_clothingStyle_content:Leather Jackets?category=198",
        "http://www.coggles.com/man/category/jackets.list#en_clothingStyle_content:Parkas and Macs?category=205",
        "http://www.coggles.com/man/category/jackets.list#en_clothingStyle_content:Quilted Jackets?category=210",
        "http://www.coggles.com/man/category/jackets.list#en_clothingStyle_content:Waistcoats?category=205",
        "http://www.coggles.com/man/category/accessories.list#en_Accessorytype_content:Bag?category=226",
        "http://www.coggles.com/man/category/accessories.list#en_Accessorytype_content:Belt?category=247",
        "http://www.coggles.com/man/category/accessories.list#en_Accessorytype_content:Gloves?category=244",
        "http://www.coggles.com/man/category/accessories.list#en_Accessorytype_content:Hat?category=240",
        "http://www.coggles.com/man/category/accessories.list#en_Accessorytype_content:iPad and Tablet Cases?category=251",
        "http://www.coggles.com/man/category/accessories.list#en_Accessorytype_content:Keyring?category=252",
        "http://www.coggles.com/man/category/accessories.list#en_Accessorytype_content:Luggage?category=226",
        "http://www.coggles.com/man/category/accessories.list#en_Accessorytype_content:Phone Case?category=251",
        "http://www.coggles.com/man/category/accessories.list#en_Accessorytype_content:Scarf?category=243",
        "http://www.coggles.com/man/category/accessories.list#en_Accessorytype_content:Sunglasses?category=237",
        "http://www.coggles.com/man/category/accessories.list#en_Accessorytype_content:Tie?category=249",
        "http://www.coggles.com/man/category/accessories.list#en_Accessorytype_content:Umbrella?category=232",
        "http://www.coggles.com/man/category/accessories.list#en_Accessorytype_content:Wallet?category=233",
        "http://www.coggles.com/man/category/shorts.list#en_clothingStyle_content:Casual Shorts?category=188",
        "http://www.coggles.com/man/category/shorts.list#en_clothingStyle_content:Denim Shorts?category=188",
        "http://www.coggles.com/man/category/shorts.list#en_clothingStyle_content:Smart Shorts?category=188",
        "http://www.coggles.com/man/category/sweatshirts.list#en_clothingStyle_content:Hoodies?category=170",
        "http://www.coggles.com/man/category/sweatshirts.list#en_clothingStyle_content:Sweatshirts?category=170",
        "http://www.coggles.com/man/category/swimshorts.list#en_brand_content:BOSS?category=260",
        "http://www.coggles.com/man/category/swimshorts.list#en_brand_content:Lacoste L!ve?category=260",
        "http://www.coggles.com/man/category/swimshorts.list#en_brand_content:Marc by Marc Jacobs?category=260",
        "http://www.coggles.com/man/category/swimshorts.list#en_brand_content:Orlebar Brown?category=260",
        "http://www.coggles.com/man/category/swimshorts.list#en_brand_content:Paul Smith Accessories?category=260",
        "http://www.coggles.com/man/category/swimshorts.list#en_brand_content:Sunspel?category=260",
        "http://www.coggles.com/man/category/t-shirts-and-tops.list#en_clothingStyle_content:Long Sleeved Tops?category=166",
        "http://www.coggles.com/man/category/t-shirts-and-tops.list#en_clothingStyle_content:Polo-Shirts?category=168",
        "http://www.coggles.com/man/category/t-shirts-and-tops.list#en_clothingStyle_content:T-Shirts?category=166",
        "http://www.coggles.com/man/category/trousers.list#en_clothingStyle_content:Casual Trousers?category=194",
        "http://www.coggles.com/man/category/trousers.list#en_clothingStyle_content:Chino?category=192",
        "http://www.coggles.com/man/category/trousers.list#en_clothingStyle_content:Smart Trousers?category=194",
        "http://www.coggles.com/man/category/trousers.list#en_clothingStyle_content:Sweatpants?category=178",
        "http://www.coggles.com/man/category/underwear.list#en_Clothingtype_content:Underwear and Nightwear?category=259",
        "http://www.coggles.com/man/category/vests.list#en_brand_content:Blood Brother?category=253",
        "http://www.coggles.com/man/category/vests.list#en_brand_content:Han Kjobenhavn?category=253",
        "http://www.coggles.com/man/category/shirts.list#en_clothingStyle_content:Denim Shirts?category=170",
        "http://www.coggles.com/man/category/shirts.list#en_clothingStyle_content:Long Sleeved Shirts?category=170",
        "http://www.coggles.com/man/category/shirts.list#en_clothingStyle_content:Short Sleeved Shirts?category=170"]
          list_cate.each do |link|
            FashionCrawler::Models::Resource.create({
              url: link.to_s,
              task: 'CogglesProcessAtCatePage',
              is_visited: false,
              site_name: 'Coggles',
              store: FashionCrawler::Models::Store.find_by(name: 'Coggles')
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


    class CogglesProcessAtCatePage
      def self.execute(url, body)
        doc = Nokogiri::HTML(body)
        begin
          category = url.scan(/category=(\d+)/).join("")
            doc.xpath("//a").each do |link|
               if link["href"].present? && link["href"].match(/\/\d+/)
                  detail_url = link["href"] + "?category=#{category}"
                  unless detail_url.match(/http/)
                    detail_url = "http://www.coggles.com" + detail_url
                  end
                  unless FashionCrawler::Models::Resource.where(url: detail_url).exists?
                    puts "!!!!!!!!!!!!#{detail_url}!!!!!!!!!!"
                    FashionCrawler::Models::Resource.create({
                    url: detail_url,
                    task: 'CogglesProcessAtDetailPage',
                    is_visited: false,
                    site_name: 'Coggles',
                    store: FashionCrawler::Models::Store.find_by(name: 'Coggles')
                    })
                  end
               end
            end
            doc.xpath("//a").each do |link|
              if link.text.match(/Next/) && link["href"].present? && link["href"].match(/pageNumber=\d+/)
                next_url = "http://www.coggles.com/woman/category/trousers.list" + link["href"] + "&category=#{category}"
                unless FashionCrawler::Models::Resource.where(url: next_url).exists?
                    puts "----------------------#{next_url}-----------------------------"
                    FashionCrawler::Models::Resource.create({
                    url: next_url,
                    task: 'CogglesProcessAtCatePage',
                    is_visited: false,
                    site_name: 'Coggles',
                    store: FashionCrawler::Models::Store.find_by(name: 'Coggles')
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

    class CogglesProcessAtDetailPage
      def self.execute(url, body)
        doc = Nokogiri::HTML(body)
        begin
          url2 = url.gsub(/category=(.)*/, "").gsub(/\?/, "").gsub(/\&/, "")
          product = FashionCrawler::Models::Item.where(link: url2).first
          if product.nil?

            item = FashionCrawler::Models::Item.new
            item.link = url2


            brand_info = doc.at_xpath("//div[@class='panel related']//h2//span")
            if brand_info.present?
              brand_name = brand_info.text.gsub(/More/, "").strip
            end

            name = doc.at_xpath("//h1[@itemprop='name']")
            item.name = name.text.strip unless name.nil?

            unless brand_name.nil?
              master_brand = MasterBrand.by_brand_name(brand_name)
              unless master_brand.nil?
                item.brand_id = master_brand.brand_id
                item.brand_name = MasterBrand.id_is_other?(item.brand_id) ? brand_name : master_brand.brand_name
                item.brand_name_ja = master_brand.brand_name_ja
              end
            end

            item.site_id = 20
            item.site_name = "Coggles"
          else
            item = product
          end

          description = doc.at_xpath("//div[@itemprop='description']")
          item.description = description.text.strip if description.present?

          original_price = doc.at_xpath("//p[@class='product-price']//span[@itemprop='price']")

          if original_price.present?
            item.original_price = original_price.text.strip
          end

          images = []
          doc.xpath("//a").each do |link|
            if link["href"].present? && link["href"].match(/300\/300/)
              images << link["href"]
            end
          end
          images.uniq!
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
          doc.xpath("//select[@id='opts-1']//option").each do |option|
            if option.text.present?
              sizes << option.text unless option.text.match(/Please choose/)
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

          number_of_products = 0
          stock_info = doc.at_xpath("//p[@class='availability']")
          if stock_info.present?
            if stock_info.text.match(/In stock/)
              number_of_products = 3
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
