# encoding: utf-8
require 'nokogiri'
require 'unicode'
require 'uri'
require 'date'
require 'open-uri'

module FashionCrawler
  module Tasks
    class BergdorfgoodmanProcessAtMainPage
      def self.execute(url, body)
        begin
          list_cate = ["http://www.bergdorfgoodman.com/Accessories/Categories/Capes-Ponchos-Vests/cat418009_cat408110_cat408107/c.cat?category=56",
          "http://www.bergdorfgoodman.com/Accessories/Categories/Wraps-Stoles/cat438500_cat408110_cat408107/c.cat?category=105",
          "http://www.bergdorfgoodman.com/Site-Map/Kids/Categories/Kids/Girls-sizes-2-6/cat261213_cat356400_cat425323/c.cat?category=312",
          "http://www.bergdorfgoodman.com/Site-Map/Kids/Categories/Kids/Girls-sizes-7-10/cat418304_cat356400_cat425323/c.cat?category=312",
          "http://www.bergdorfgoodman.com/Site-Map/Kids/Categories/Kids/Boys-sizes-2-6/cat261212_cat356400_cat425323/c.cat?category=293",
          "http://www.bergdorfgoodman.com/Site-Map/Kids/Categories/Kids/Boys-sizes-7-10/cat418305_cat356400_cat425323/c.cat?category=293",
          "http://www.bergdorfgoodman.com/Site-Map/Kids/Categories/Kids/Shoes/cat271002_cat356400_cat425323/c.cat?category=290",
          "http://www.bergdorfgoodman.com/Site-Map/Kids/Categories/Kids/Accessories/cat413106_cat356400_cat425323/c.cat?category=293",
          "http://www.bergdorfgoodman.com/Site-Map/Kids/Categories/Kids/Toys/cat403003_cat356400_cat425323/c.cat?category=330",
          "http://www.bergdorfgoodman.com/Mens-Store/Accessories/Belts/cat214308_cat413612_cat202802/c.cat?category=247",
          "http://www.bergdorfgoodman.com/Mens-Store/Accessories/Bags-Briefcases/cat214310_cat413612_cat202802/c.cat?category=226",
          "http://www.bergdorfgoodman.com/Mens-Store/Accessories/Wallets-Keychains/cat214309_cat413612_cat202802/c.cat?category=233",
          "http://www.bergdorfgoodman.com/Mens-Store/Accessories/Ties-Pocket-Squares/cat213541_cat413612_cat202802/c.cat?category=249",
          "http://www.bergdorfgoodman.com/Mens-Store/Accessories/Sunglasses-Optical/cat216801_cat413612_cat202802/c.cat?category=237",
          "http://www.bergdorfgoodman.com/Mens-Store/Accessories/Cuff-Links/cat213532_cat413612_cat202802/c.cat?category=250",
          "http://www.bergdorfgoodman.com/Mens-Store/Accessories/Scarves-Hats-Gloves/cat261801_cat413612_cat202802/c.cat?category=244",
          "http://www.bergdorfgoodman.com/Mens-Store/Accessories/Jewelry-Watches/cat267608_cat413612_cat202802/c.cat?category=231",
          "http://www.bergdorfgoodman.com/Accessories/Categories/Sunglasses-Eyewear/Optical-Frames/cat408119_cat414714_cat408110/c.cat?category=100",
          "http://www.bergdorfgoodman.com/Mens-Store/Clothing/Suits-Blazers/cat255915_cat000024_cat202802/c.cat?category=200",
          "http://www.bergdorfgoodman.com/Mens-Store/Clothing/Casual-Shirts/cat256706_cat000024_cat202802/c.cat?category=170",
          "http://www.bergdorfgoodman.com/Mens-Store/Clothing/Denim/Relaxed/cat428926_cat372500_cat000024/c.cat?category=183",
          "http://www.bergdorfgoodman.com/Mens-Store/Clothing/Denim/Straight/cat428924_cat372500_cat000024/c.cat?category=180",
          "http://www.bergdorfgoodman.com/Mens-Store/Clothing/Denim/Slim/cat428925_cat372500_cat000024/c.cat?category=182",
          "http://www.bergdorfgoodman.com/Mens-Store/Clothing/Dress-Shirts/cat213528_cat000024_cat202802/c.cat?category=176",
          "http://www.bergdorfgoodman.com/Mens-Store/Clothing/Pants-Shorts/cat255914_cat000024_cat202802/c.cat?category=188",
          "http://www.bergdorfgoodman.com/Mens-Store/Clothing/Swim/cat378509_cat000024_cat202802/c.cat?category=260",
          "http://www.bergdorfgoodman.com/Mens-Store/Clothing/Sweaters/cat366201_cat000024_cat202802/c.cat?category=173",
          "http://www.bergdorfgoodman.com/Mens-Store/Clothing/Formalwear/cat429701_cat000024_cat202802/c.cat?category=263",
          "http://www.bergdorfgoodman.com/Mens-Store/Clothing/Coats-Jackets/Leather-Suede/cat428919_cat213524_cat000024/c.cat?category=198",
          "http://www.bergdorfgoodman.com/Mens-Store/Clothing/Coats-Jackets/Quilted-Puffers/cat428916_cat213524_cat000024/c.cat?category=195",
          "http://www.bergdorfgoodman.com/Mens-Store/Clothing/Coats-Jackets/Lightweight/cat428920_cat213524_cat000024/c.cat?category=197",
          "http://www.bergdorfgoodman.com/Mens-Store/Clothing/Coats-Jackets/Vests/cat428917_cat213524_cat000024/c.cat?category=207",
          "http://www.bergdorfgoodman.com/Mens-Store/Mens-Grooming/Mens-Fragrances/cat243443_cat364602_cat202802/c.cat?category=245",
          "http://www.bergdorfgoodman.com/Accessories/Categories/Gloves/cat415106_cat408110_cat408107/c.cat?category=108",
          "http://www.bergdorfgoodman.com/Jewelry-Accessories/Categories/Rings/cat203516_cat203104_cat202801/c.cat?category=92",
          "http://www.bergdorfgoodman.com/Accessories/Categories/Belts/cat408113_cat408110_cat408107/c.cat?category=109",
          "http://www.bergdorfgoodman.com/Accessories/Categories/Scarves/cat408112_cat408110_cat408107/c.cat?category=105",
          "http://www.bergdorfgoodman.com/Handbags/Categories/Satchels/cat290700_cat260104_cat257221/c.cat?category=78",
          "http://www.bergdorfgoodman.com/Jewelry-Accessories/Categories/Bracelets/cat203515_cat203104_cat202801/c.cat?category=93",
          "http://www.bergdorfgoodman.com/Handbags/Categories/Evening-Bags/cat289102_cat260104_cat257221/c.cat?category=78",
          "http://www.bergdorfgoodman.com/Handbags/Categories/Hobos/cat368203_cat260104_cat257221/c.cat?category=78",
          "http://www.bergdorfgoodman.com/Handbags/Categories/Top-Handles/cat207302_cat260104_cat257221/c.cat?category=78",
          "http://www.bergdorfgoodman.com/Jewelry-Accessories/Categories/Necklaces/Statement/cat432329_cat203514_cat203104/c.cat?category=90",
          "http://www.bergdorfgoodman.com/Jewelry-Accessories/Categories/Necklaces/Chain-Strand/cat432330_cat203514_cat203104/c.cat?category=90",
          "http://www.bergdorfgoodman.com/Jewelry-Accessories/Categories/Necklaces/Enhancers-Charms/cat432331_cat203514_cat203104/c.cat?category=90",
          "http://www.bergdorfgoodman.com/Jewelry-Accessories/Categories/Earrings/cat203401_cat203104_cat202801/c.cat?category=91",
          "http://www.bergdorfgoodman.com/Handbags/Categories/Small-Accessories-Wallets/cat238100_cat260104_cat257221/c.cat?category=120",
          "http://www.bergdorfgoodman.com/Handbags/Categories/Totes/cat207303_cat260104_cat257221/c.cat?category=77",
          "http://www.bergdorfgoodman.com/Handbags/Categories/5F-Contemporary/cat232700_cat260104_cat257221/c.cat?category=78",
          "http://www.bergdorfgoodman.com/Shoe-Salon/Categories/5F-Contemporary/Pumps/cat380416_cat234400_cat203509/c.cat?category=60",
          "http://www.bergdorfgoodman.com/Shoe-Salon/Categories/5F-Contemporary/Flats/cat380414_cat234400_cat203509/c.cat?category=71",
          "http://www.bergdorfgoodman.com/Shoe-Salon/Categories/5F-Contemporary/Sandals/cat380415_cat234400_cat203509/c.cat?category=58",
          "http://www.bergdorfgoodman.com/Shoe-Salon/Categories/5F-Contemporary/Wedges/cat380417_cat234400_cat203509/c.cat?category=63",
          "http://www.bergdorfgoodman.com/Shoe-Salon/Categories/5F-Contemporary/Boots/cat380410_cat234400_cat203509/c.cat?category=76",
          "http://www.bergdorfgoodman.com/Handbags/Categories/Shoulder-Bags/cat207300_cat260104_cat257221/c.cat?category=82",
          "http://www.bergdorfgoodman.com/5F-Contemporary/5F-Apparel/Pants-Shorts/Pants/cat363305_cat291117_cat232503/c.cat?category=17",
          "http://www.bergdorfgoodman.com/5F-Contemporary/5F-Apparel/Pants-Shorts/Shorts/cat362900_cat291117_cat232503/c.cat?category=18",
          "http://www.bergdorfgoodman.com/5F-Contemporary/5F-Apparel/Pants-Shorts/Jumpsuits/cat363304_cat291117_cat232503/c.cat?category=37",
          "http://www.bergdorfgoodman.com/5F-Contemporary/5F-Apparel/Pants-Shorts/Leggings/cat363301_cat291117_cat232503/c.cat?category=113",
          "http://www.bergdorfgoodman.com/Handbags/Categories/Clutches/cat289101_cat260104_cat257221/c.cat?category=81",
          "http://www.bergdorfgoodman.com/Shoe-Salon/Categories/Evening/cat207102_cat203509_cat200648/c.cat?category=62",
          "http://www.bergdorfgoodman.com/5F-Contemporary/5F-Apparel/Skirts/cat276832_cat232503_cat230300/c.cat?category=15",
          "http://www.bergdorfgoodman.com/5F-Contemporary/5F-Apparel/Jackets-Vests/cat226506_cat232503_cat230300/c.cat?category=47",
          "http://www.bergdorfgoodman.com/Shoe-Salon/Categories/Boots/Booties/cat375504_cat379627_cat203509/c.cat?category=72",
          "http://www.bergdorfgoodman.com/Shoe-Salon/Categories/Boots/Tall/cat379626_cat379627_cat203509/c.cat?category=68",
          "http://www.bergdorfgoodman.com/Shoe-Salon/Categories/Boots/Short/cat321508_cat379627_cat203509/c.cat?category=69",
          "http://www.bergdorfgoodman.com/Shoe-Salon/Categories/Boots/All-Weather/cat379628_cat379627_cat203509/c.cat?category=110",
          "http://www.bergdorfgoodman.com/5F-Contemporary/5F-Apparel/Dresses/Cocktail/cat368009_cat234605_cat232503/c.cat?category=352",
          "http://www.bergdorfgoodman.com/5F-Contemporary/5F-Apparel/Dresses/Weekend/cat268800_cat234605_cat232503/c.cat?category=351",
          "http://www.bergdorfgoodman.com/5F-Contemporary/5F-Apparel/Dresses/Work/cat260345_cat234605_cat232503/c.cat?category=144",
          "http://www.bergdorfgoodman.com/5F-Contemporary/5F-Apparel/Dresses/Little-Black-Dress/cat363104_cat234605_cat232503/c.cat?category=144",
          "http://www.bergdorfgoodman.com/Shoe-Salon/Categories/Flats/cat10013_cat203509_cat200648/c.cat?category=64",
          "http://www.bergdorfgoodman.com/Shoe-Salon/Categories/Sneakers/cat396600_cat203509_cat200648/c.cat?category=59",
          "http://www.bergdorfgoodman.com/5F-Contemporary/5F-Apparel/Sleepwear/Pajamas/cat428704_cat428703_cat232503/c.cat?category=126",
          "http://www.bergdorfgoodman.com/5F-Contemporary/5F-Apparel/Sleepwear/Gowns/cat428705_cat428703_cat232503/c.cat?category=127",
          "http://www.bergdorfgoodman.com/5F-Contemporary/5F-Apparel/Sleepwear/Chemises-Babydolls/cat428706_cat428703_cat232503/c.cat?category=126",
          "http://www.bergdorfgoodman.com/5F-Contemporary/5F-Apparel/Sleepwear/Sleepshirts/cat428707_cat428703_cat232503/c.cat?category=126",
          "http://www.bergdorfgoodman.com/5F-Contemporary/5F-Apparel/Sleepwear/Robes-Caftans/cat213107_cat428703_cat232503/c.cat?category=128",
          "http://www.bergdorfgoodman.com/5F-Contemporary/5F-Apparel/Lingerie/Bras/cat213104_cat213103_cat232503/c.cat?category=124",
          "http://www.bergdorfgoodman.com/5F-Contemporary/5F-Apparel/Lingerie/Panties/cat213105_cat213103_cat232503/c.cat?category=121",
          "http://www.bergdorfgoodman.com/5F-Contemporary/5F-Apparel/Lingerie/Slips-Bodysuits/cat213106_cat213103_cat232503/c.cat?category=350",
          "http://www.bergdorfgoodman.com/5F-Contemporary/5F-Apparel/Lingerie/Shapewear/cat428708_cat213103_cat232503/c.cat?category=129",
          "http://www.bergdorfgoodman.com/5F-Contemporary/5F-Apparel/Lingerie/Hosiery/cat215302_cat213103_cat232503/c.cat?category=114",
          "http://www.bergdorfgoodman.com/5F-Contemporary/5F-Apparel/Lingerie/Daywear/cat417907_cat213103_cat232503/c.cat?category=122",
          "http://www.bergdorfgoodman.com/Designer-Collections/Categories/Pants-Shorts/Ankle/cat301020_cat276903_cat000009/c.cat?category=17",
          "http://www.bergdorfgoodman.com/Designer-Collections/Categories/Pants-Shorts/Skinny/cat290920_cat276903_cat000009/c.cat?category=32",
          "http://www.bergdorfgoodman.com/Designer-Collections/Categories/Pants-Shorts/Straight-Leg/cat351915_cat276903_cat000009/c.cat?category=344",
          "http://www.bergdorfgoodman.com/Designer-Collections/Categories/Pants-Shorts/Shorts/cat362901_cat276903_cat000009/c.cat?category=18",
          "http://www.bergdorfgoodman.com/Designer-Collections/Categories/Pants-Shorts/Wide-Leg/cat290921_cat276903_cat000009/c.cat?category=33",
          "http://www.bergdorfgoodman.com/Designer-Collections/Categories/Pants-Shorts/Denim/cat425326_cat276903_cat000009/c.cat?category=28",
          "http://www.bergdorfgoodman.com/Shoe-Salon/Categories/Pumps/Peep-Toe/cat378603_cat379623_cat203509/c.cat?category=60",
          "http://www.bergdorfgoodman.com/Shoe-Salon/Categories/Pumps/Pointed-Toe-Pump/cat413800_cat379623_cat203509/c.cat?category=60",
          "http://www.bergdorfgoodman.com/Shoe-Salon/Categories/Pumps/Closed-Toe/cat10015_cat379623_cat203509/c.cat?category=60",
          "http://www.bergdorfgoodman.com/Shoe-Salon/Categories/Pumps/Slingbacks/cat379510_cat379623_cat203509/c.cat?category=60",
          "http://www.bergdorfgoodman.com/Shoe-Salon/Categories/Pumps/The-dOrsay/cat379513_cat379623_cat203509/c.cat?category=60",
          "http://www.bergdorfgoodman.com/Shoe-Salon/Categories/Wedges/cat223300_cat203509_cat200648/c.cat?category=63",
          "http://www.bergdorfgoodman.com/Shoe-Salon/Categories/Sandals/cat10012_cat203509_cat200648/c.cat?category=58",
          "http://www.bergdorfgoodman.com/Kids/Baby/Girls-3-36-months/cat413102_cat413109_cat000006/c.cat?category=330",
          "http://www.bergdorfgoodman.com/Kids/Baby/Boys-3-36-months/cat413103_cat413109_cat000006/c.cat?category=330",
          "http://www.bergdorfgoodman.com/Kids/Baby/Layette-0-24-months/cat261214_cat413109_cat000006/c.cat?category=330",
          "http://www.bergdorfgoodman.com/Kids/Baby/Shoes/cat413104_cat413109_cat000006/c.cat?category=275",
          "http://www.bergdorfgoodman.com/Kids/Baby/Accessories/cat413105_cat413109_cat000006/c.cat?category=330",
          "http://www.bergdorfgoodman.com/Kids/Baby/Diaper-Bags/cat379602_cat413109_cat000006/c.cat?category=325",
          "http://www.bergdorfgoodman.com/Kids/Baby/Strollers-Accessories/cat369100_cat413109_cat000006/c.cat?category=326",
          "http://www.bergdorfgoodman.com/Designer-Collections/Categories/Jackets/cat255908_cat000009_cat000002/c.cat?category=47",
          "http://www.bergdorfgoodman.com/Designer-Collections/Categories/Skirts/cat276904_cat000009_cat000002/c.cat?category=15",
          "http://www.bergdorfgoodman.com/5F-Contemporary/5F-Apparel/Coats/cat240005_cat232503_cat230300/c.cat?category=209",
          "http://www.bergdorfgoodman.com/Designer-Collections/Categories/Cold-Weather-Shop/Coats/cat428709_cat303301_cat000009/c.cat?category=209",
          "http://www.bergdorfgoodman.com/Designer-Collections/Categories/Cold-Weather-Shop/Scarves/cat408112_cat303301_cat000009/c.cat?category=105",
          "http://www.bergdorfgoodman.com/Designer-Collections/Categories/Cold-Weather-Shop/Capes-Ponchos-Vests/cat418009_cat303301_cat000009/c.cat?category=56",
          "http://www.bergdorfgoodman.com/Designer-Collections/Categories/Cold-Weather-Shop/Gloves/cat415106_cat303301_cat000009/c.cat?category=108",
          "http://www.bergdorfgoodman.com/Designer-Collections/Categories/Cold-Weather-Shop/Boots/cat379627_cat303301_cat000009/c.cat?category=76",
          "http://www.bergdorfgoodman.com/Designer-Collections/Categories/Dresses/Day/cat363106_cat80001_cat000009/c.cat?category=351",
          "http://www.bergdorfgoodman.com/Designer-Collections/Categories/Dresses/Cocktail/cat285304_cat80001_cat000009/c.cat?category=143",
          "http://www.bergdorfgoodman.com/Designer-Collections/Categories/Dresses/Gowns/cat285305_cat80001_cat000009/c.cat?category=127",
          "http://www.bergdorfgoodman.com/Designer-Collections/Categories/Dresses/5F-Dresses/cat234605_cat80001_cat000009/c.cat?category=144",
          "http://www.bergdorfgoodman.com/5F-Contemporary/5F-Apparel/Tops/Blouses/cat260342_cat100009_cat232503/c.cat?category=10",
          "http://www.bergdorfgoodman.com/5F-Contemporary/5F-Apparel/Tops/Knits/cat364401_cat100009_cat232503/c.cat?category=6",
          "http://www.bergdorfgoodman.com/5F-Contemporary/5F-Apparel/Tops/Sweaters/cat259305_cat100009_cat232503/c.cat?category=6",
          "http://www.bergdorfgoodman.com/5F-Contemporary/5F-Apparel/Tops/Tanks-Halters/cat260341_cat100009_cat232503/c.cat?category=1",
          "http://www.bergdorfgoodman.com/5F-Contemporary/5F-Apparel/Denim/By-Designer/cat219201_cat219200_cat232503/c.cat?category=28",
          "http://www.bergdorfgoodman.com/5F-Contemporary/5F-Apparel/Denim/By-Style/cat219203_cat219200_cat232503/c.cat?category=28",
          "http://www.bergdorfgoodman.com/5F-Contemporary/5F-Apparel/Swim/Swim/cat265504_cat201101_cat232503/c.cat?category=132",
          "http://www.bergdorfgoodman.com/5F-Contemporary/5F-Apparel/Swim/By-Silhouette/cat387503_cat201101_cat232503/c.cat?category=132",
          "http://www.bergdorfgoodman.com/5F-Contemporary/5F-Apparel/Swim/Cover-ups/cat354802_cat201101_cat232503/c.cat?category=133",
          "http://www.bergdorfgoodman.com/5F-Contemporary/5F-Apparel/Swim/Sunglasses-Eyewear/cat414714_cat201101_cat232503/c.cat?category=100",
          "http://www.bergdorfgoodman.com/Mens-Store/Shoes/Sneakers/cat226105_cat213529_cat202802/c.cat?category=213",
          "http://www.bergdorfgoodman.com/Mens-Store/Shoes/Loafers-Slip-Ons/cat228702_cat213529_cat202802/c.cat?category=216",
          "http://www.bergdorfgoodman.com/Mens-Store/Shoes/Drivers/cat228701_cat213529_cat202802/c.cat?category=217",
          "http://www.bergdorfgoodman.com/Mens-Store/Shoes/Sandals/cat246200_cat213529_cat202802/c.cat?category=212",
          "http://www.bergdorfgoodman.com/Mens-Store/Shoes/Dress-Shoes/cat437712_cat213529_cat202802/c.cat?category=214",
          "http://www.bergdorfgoodman.com/Mens-Store/Shoes/Oxfords/cat240502_cat213529_cat202802/c.cat?category=214",
          "http://www.bergdorfgoodman.com/Mens-Store/Shoes/Boots/cat227202_cat213529_cat202802/c.cat?category=215",
          "http://www.bergdorfgoodman.com/Designer-Collections/Categories/Tops/Blouses/cat261704_cat364409_cat000009/c.cat?category=10",
          "http://www.bergdorfgoodman.com/Designer-Collections/Categories/Tops/Sweaters/cat259401_cat364409_cat000009/c.cat?category=6",
          "http://www.bergdorfgoodman.com/Designer-Collections/Categories/Tops/Cardigans/cat364403_cat364409_cat000009/c.cat?category=7",
          "http://www.bergdorfgoodman.com/Designer-Collections/Categories/Tops/Knits/cat364410_cat364409_cat000009/c.cat?category=6",
          "http://www.bergdorfgoodman.com/Designer-Collections/Categories/Tops/The-Ten-White-Blouses/cat395504_cat364409_cat000009/c.cat?category=10"]
          list_cate.each do |link|
            FashionCrawler::Models::Resource.create({
              url: link.to_s,
              task: 'BergdorfgoodmanProcessAtCatePage',
              is_visited: false,
              site_name: 'Bergdorfgoodman',
              store: FashionCrawler::Models::Store.find_by(name: 'Bergdorfgoodman')
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


    class BergdorfgoodmanProcessAtCatePage
      def self.execute(url, body)
        doc = Nokogiri::HTML(body)
        begin
          category = url.scan(/category=(\d+)/).join("")
            doc.xpath("//div[@class='products']//a").each do |link|
               if link["href"].present? && link["href"].match(/prod\d+_cat\d+/)
                  detail_url = "http://www.bergdorfgoodman.com" + link["href"] + "&category=#{category}"
                  unless FashionCrawler::Models::Resource.where(url: detail_url).exists?
                    puts "!!!!!!!!!!!!#{detail_url}!!!!!!!!!!"
                    FashionCrawler::Models::Resource.create({
                    url: detail_url,
                    task: 'BergdorfgoodmanProcessAtDetailPage',
                    is_visited: false,
                    site_name: 'Bergdorfgoodman',
                    store: FashionCrawler::Models::Store.find_by(name: 'Bergdorfgoodman')
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

    class BergdorfgoodmanProcessAtDetailPage
      def self.execute(url, body)
        doc = Nokogiri::HTML(body)
        begin
          url2 = url.gsub(/\&category=(.)*/, "")
          product = FashionCrawler::Models::Item.where(link: url2).first
          if product.nil?

            item = FashionCrawler::Models::Item.new
            item.link = url2

            brand_node = doc.at_xpath("//span[@itemprop='brand']")
            brand_name = brand_node.text.strip if brand_node.present?

            name = doc.at_xpath("//h1[@itemprop='name']")
            item.name = name.text.gsub(brand_name, "").strip unless name.nil?

            unless brand_name.nil?
              master_brand = MasterBrand.by_brand_name(brand_name)
              unless master_brand.nil?
                item.brand_id = master_brand.brand_id
                item.brand_name = MasterBrand.id_is_other?(item.brand_id) ? brand_name : master_brand.brand_name
                item.brand_name_ja = master_brand.brand_name_ja
              end
            end

            item.site_id = 16
            item.site_name = "Bergdorfgoodman"
          else
            item = product
          end

          description = doc.at_xpath("//div[@itemprop='description']")
          item.description = description.text if description.present?

          original_price = doc.at_xpath("//span[@itemprop='price']")


          if original_price.present?
            item.original_price = original_price.text.gsub(/,/, "")
            item.price = CurrencyRate.convert_price_to_yen("USD", item.original_price, "$")
          end

          images = []
          doc.xpath("//div[@class='views']//li//img").each do |img|
            if img["src"].to_s.match(/g.jpg/)
              images << img["src"].to_s.gsub(/g.jpg/, "z.jpg")
            end
          end
          item.images = images.join(",")


          category = url.scan(/\&category=(\d+)/).join('')
          item.category_id = category
          master_category = MasterCategory.by_category_3_id(category.to_i)
          unless master_category.nil?
            item.category_name = master_category.category_3
            general_category_id = master_category.general_category_id
          end

          number_of_products = 0
          body.scan(/'In Stock'/).each do |item|
            number_of_products = number_of_products + 3
          end

          if number_of_products > 0
             item.flag = 1
             item.number_of_products = number_of_products
          else
             item.flag = 0
          end

          sizes = []
          body.scan(/new product(.*);/).each do |size|
            item_size = size.first.to_s.split(",")[3].gsub(/'/, "")
            sizes << item_size
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

          if item.name.present? && item.price.present? && category.to_i > 0 && item.flag == 1
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
