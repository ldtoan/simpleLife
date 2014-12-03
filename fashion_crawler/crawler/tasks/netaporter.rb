# encoding: utf-8
require 'nokogiri'
require 'unicode'
require 'uri'
require 'date'

# CATEGORIES_KARMALOOP = ["clothing", "footwear", "accessories", "beauty"]
# NOCRAWLING_KARMALOOP = ["womens/clothing/dresses/sweater", "womens/clothing/sweatshirts/jackets", "womens/footwear/shoes/lace-up", "womens/beauty/makeup/body", "womens/beauty/makeup/lips", "womens/beauty/makeup/nails", "mens/accessories/grooming-fragrance/shave", "womens/accessories/bags/Duffle-Bags", "womens/accessories/hats/Dress-Hats", "womens/accessories/bags/duffle-bags", "womens/accessories/hats/dress-hats"]

module FashionCrawler
  module Tasks
    class NetAPorterProcessAtMainPage
     def self.execute(url, body)
      begin
        # ["http://www.net-a-porter.com/Shop/Clothing?cm_sp=topnav-clothing-allclothing", "http://www.net-a-porter.com/Shop/Bags?cm_sp=topnav-bags-allbags", "http://www.net-a-porter.com/Shop/Shoes?cm_sp=topnav-shoes-allshoes", "http://www.net-a-porter.com/Shop/Accessories?cm_sp=topnav-accessories-allaccessories", "http://www.net-a-porter.com/Shop/Lingerie?cm_sp=topnav-lingerie-alllingerie", "http://www.net-a-porter.com/Shop/Beauty?cm_sp=topnav-beauty-allbeauty"].each do |link|
        ['http://www.net-a-porter.com/Shop/Shoes/Boots?level3Filter=Flat&category=71',
        'http://www.net-a-porter.com/Shop/Shoes/Boots?level3Filter=Mid_Heel&category=72',
        'http://www.net-a-porter.com/Shop/Shoes/Boots?level3Filter=High_Heel&category=72',
        'http://www.net-a-porter.com/Shop/Shoes/Boots?level3Filter=Ankle_Boots&category=72',
        'http://www.net-a-porter.com/Shop/Shoes/Boots?level3Filter=Knee_Boots&category=68',
        'http://www.net-a-porter.com/Shop/Shoes/Boots?level3Filter=Rain_Boots&category=110',
        'http://www.net-a-porter.com/Shop/Shoes/Boots?level3Filter=Over_the_Knee&category=70',
        'http://www.net-a-porter.com/Shop/Shoes/Boots?level3Filter=Apres-Ski_and_Shearling&category=69',
        'http://www.net-a-porter.com/Shop/Shoes/Sandals?level3Filter=Flat&category=58',
        'http://www.net-a-porter.com/Shop/Shoes/Sandals?level3Filter=Mid_Heel&category=58',
        'http://www.net-a-porter.com/Shop/Shoes/Sandals?level3Filter=High_Heel&category=58',
        'http://www.net-a-porter.com/Shop/Shoes/Sandals?level3Filter=Block_Heel&category=58',
        'http://www.net-a-porter.com/Shop/Shoes/Sandals?level3Filter=Mules&category=58',
        'http://www.net-a-porter.com/Shop/Shoes/Sandals?level3Filter=Platforms&category=58',
        'http://www.net-a-porter.com/Shop/Shoes/Sandals?level3Filter=Slides&category=58',
        'http://www.net-a-porter.com/Shop/Shoes/Sandals?level3Filter=Wedges&category=58',
        'http://www.net-a-porter.com/Shop/Shoes/Sandals?level3Filter=Bridal&category=58',
        'http://www.net-a-porter.com/Shop/Shoes/Flat_Shoes?level3Filter=Ballet_Flats&category=64',
        'http://www.net-a-porter.com/Shop/Shoes/Flat_Shoes?level3Filter=Espadrilles&category=66',
        'http://www.net-a-porter.com/Shop/Shoes/Flat_Shoes?level3Filter=Lace_Ups&category=64',
        'http://www.net-a-porter.com/Shop/Shoes/Flat_Shoes?level3Filter=Loafers&category=65',
        'http://www.net-a-porter.com/Shop/Shoes/Flat_Shoes?level3Filter=Moccasins&category=64',
        'http://www.net-a-porter.com/Shop/Shoes/Flat_Shoes?level3Filter=Pointed-Toe_Flats&category=64',
        'http://www.net-a-porter.com/Shop/Shoes/Flat_Shoes?level3Filter=Slippers&category=122',
        'http://www.net-a-porter.com/Shop/Accessories/Belts?level3Filter=Skinny&category=109',
        'http://www.net-a-porter.com/Shop/Accessories/Belts?level3Filter=Wide&category=109',
        'http://www.net-a-porter.com/Shop/Shoes/Pumps?level3Filter=Mid_Heel&category=60',
        'http://www.net-a-porter.com/Shop/Shoes/Pumps?level3Filter=High_Heel&category=60',
        'http://www.net-a-porter.com/Shop/Shoes/Pumps?level3Filter=Platforms&category=60',
        'http://www.net-a-porter.com/Shop/Shoes/Pumps?level3Filter=Peep_Toe&category=60',
        'http://www.net-a-porter.com/Shop/Shoes/Pumps?level3Filter=Bridal&category=60',
        'http://www.net-a-porter.com/Shop/Shoes/Sneakers?level3Filter=Flat&category=59',
        'http://www.net-a-porter.com/Shop/Shoes/Sneakers?level3Filter=Fashion_Runners&category=59',
        'http://www.net-a-porter.com/Shop/Shoes/Sneakers?level3Filter=Slip-On&category=59',
        'http://www.net-a-porter.com/Shop/Shoes/Sneakers?level3Filter=Wedge&category=59',
        'http://www.net-a-porter.com/Shop/Accessories/Books?level3Filter=Fashion&category=120',
        'http://www.net-a-porter.com/Shop/Accessories/Books?level3Filter=Art_and_Photography&category=120',
        'http://www.net-a-porter.com/Shop/Accessories/Books?level3Filter=Lifestyle_and_Travel&category=120',
        'http://www.net-a-porter.com/Shop/Accessories/Books?level3Filter=Limited_Edition&category=120',
        'http://www.net-a-porter.com/Shop/Accessories/Fine_Jewelry?level3Filter=Rings&category=92',
        'http://www.net-a-porter.com/Shop/Accessories/Fine_Jewelry?level3Filter=Earrings&category=91',
        'http://www.net-a-porter.com/Shop/Accessories/Fine_Jewelry?level3Filter=Drop&category=91',
        'http://www.net-a-porter.com/Shop/Accessories/Fine_Jewelry?level3Filter=Ear_Cuff&category=91',
        'http://www.net-a-porter.com/Shop/Accessories/Fine_Jewelry?level3Filter=Stud&category=91',
        'http://www.net-a-porter.com/Shop/Accessories/Fine_Jewelry?level3Filter=Necklaces&category=90',
        'http://www.net-a-porter.com/Shop/Accessories/Fine_Jewelry?level3Filter=Bracelets&category=93',
        'http://www.net-a-porter.com/Shop/Accessories/Fine_Jewelry?level3Filter=Bridal&category=138',
        'http://www.net-a-porter.com/Shop/Accessories/Gloves&category=108',
        'http://www.net-a-porter.com/Shop/Accessories/Hats?level3Filter=Beanies&category=103',
        'http://www.net-a-porter.com/Shop/Accessories/Hats?level3Filter=Caps&category=103',
        'http://www.net-a-porter.com/Shop/Accessories/Hats?level3Filter=Fedoras&category=103',
        'http://www.net-a-porter.com/Shop/Accessories/Hats?level3Filter=Sunhats&category=103',
        'http://www.net-a-porter.com/Shop/Accessories/Collars&category=120',
        'http://www.net-a-porter.com/Shop/Accessories/Jewelry?level3Filter=Rings&category=92',
        'http://www.net-a-porter.com/Shop/Accessories/Jewelry?level3Filter=Earrings&category=91',
        'http://www.net-a-porter.com/Shop/Accessories/Jewelry?level3Filter=Clip&category=120',
        'http://www.net-a-porter.com/Shop/Accessories/Jewelry?level3Filter=Stud&category=120',
        'http://www.net-a-porter.com/Shop/Accessories/Jewelry?level3Filter=Necklaces&category=90',
        'http://www.net-a-porter.com/Shop/Accessories/Jewelry?level3Filter=Bracelets&category=93',
        'http://www.net-a-porter.com/Shop/Accessories/Jewelry?level3Filter=Cuffs&category=120',
        'http://www.net-a-porter.com/Shop/Accessories/Jewelry?level3Filter=Handpiece&category=120',
        'http://www.net-a-porter.com/Shop/Accessories/Jewelry?level3Filter=Brooches&category=119',
        'http://www.net-a-porter.com/Shop/Accessories/Jewelry?level3Filter=Bridal&category=138',
        'http://www.net-a-porter.com/Shop/Accessories/Jewelry?level3Filter=Jewelry_Cases&category=120',
        'http://www.net-a-porter.com/Shop/Accessories/Jewelry?level3Filter=Body_Jewelry&category=120',
        'http://www.net-a-porter.com/Shop/Accessories/Homeware?level3Filter=Candles&category=120',
        'http://www.net-a-porter.com/Shop/Accessories/Homeware?level3Filter=Clothing_Care&category=120',
        'http://www.net-a-porter.com/Shop/Accessories/Homeware?level3Filter=Collectables&category=120',
        'http://www.net-a-porter.com/Shop/Accessories/Homeware?level3Filter=Cushions&category=120',
        'http://www.net-a-porter.com/Shop/Accessories/Key_Fobs&category=112',
        'http://www.net-a-porter.com/Shop/Accessories/Opticals&category=120',
        'http://www.net-a-porter.com/Shop/Accessories/Hair_Accessories?level3Filter=Hairclips&category=96',
        'http://www.net-a-porter.com/Shop/Accessories/Hair_Accessories?level3Filter=Headbands&category=104',
        'http://www.net-a-porter.com/Shop/Accessories/Hair_Accessories?level3Filter=Headpieces&category=96',
        'http://www.net-a-porter.com/Shop/Accessories/Hair_Accessories?level3Filter=Veils&category=140',
        'http://www.net-a-porter.com/Shop/Accessories/Pouches&category=118',
        'http://www.net-a-porter.com/Shop/Accessories/Sunglasses?level3Filter=Aviator&category=100',
        'http://www.net-a-porter.com/Shop/Accessories/Sunglasses?level3Filter=Cat-Eye&category=100',
        'http://www.net-a-porter.com/Shop/Accessories/Sunglasses?level3Filter=D-Frame&category=100',
        'http://www.net-a-porter.com/Shop/Accessories/Sunglasses?level3Filter=Round_Frame&category=100',
        'http://www.net-a-porter.com/Shop/Accessories/Sunglasses?level3Filter=Square_Frame&category=100',
        'http://www.net-a-porter.com/Shop/Accessories/Stationery&category=120',
        'http://www.net-a-porter.com/Shop/Accessories/Travel&category=120',
        'http://www.net-a-porter.com/Shop/Accessories/Scarves?level3Filter=Cashmere&category=105',
        'http://www.net-a-porter.com/Shop/Accessories/Scarves?level3Filter=Silk&category=105',
        'http://www.net-a-porter.com/Shop/Accessories/Umbrellas&category=110',
        'http://www.net-a-porter.com/Shop/Accessories/Technology?level3Filter=Phone_Cases&category=111',
        'http://www.net-a-porter.com/Shop/Accessories/Technology?level3Filter=iPhone_5_Cases&category=111',
        'http://www.net-a-porter.com/Shop/Accessories/Technology?level3Filter=Tablet_Cases&category=111',
        'http://www.net-a-porter.com/Shop/Accessories/Technology?level3Filter=Laptop_Cases&category=111',
        'http://www.net-a-porter.com/Shop/Accessories/Technology?level3Filter=Headphones&category=111',
        'http://www.net-a-porter.com/Shop/Bags/Belt_Bags&category=109',
        'http://www.net-a-porter.com/Shop/Accessories/Wallets?level3Filter=Cardholders&category=86',
        'http://www.net-a-porter.com/Shop/Accessories/Wallets?level3Filter=Wallets&category=86',
        'http://www.net-a-porter.com/Shop/Accessories/Watches&category=98',
        'http://www.net-a-porter.com/Shop/Bags/Backpacks&category=84',
        'http://www.net-a-porter.com/Shop/Bags/Travel_Bags?level3Filter=Holdall&category=364',
        'http://www.net-a-porter.com/Shop/Bags/Travel_Bags?level3Filter=Rolling&category=364',
        'http://www.net-a-porter.com/Shop/Bags/Clutch_Bags?level3Filter=Box&category=81',
        'http://www.net-a-porter.com/Shop/Bags/Clutch_Bags?level3Filter=Novelty&category=81',
        'http://www.net-a-porter.com/Shop/Bags/Clutch_Bags?level3Filter=Pouch&category=81',
        'http://www.net-a-porter.com/Shop/Bags/Clutch_Bags?level3Filter=Bridal&category=81',
        'http://www.net-a-porter.com/Shop/Bags/Tote_Bags?level3Filter=Shoulder_Strap&category=77',
        'http://www.net-a-porter.com/Shop/Bags/Tote_Bags?level3Filter=Trapeze&category=77',
        'http://www.net-a-porter.com/Shop/Bags/Tote_Bags?level3Filter=Beach&category=77',
        'http://www.net-a-porter.com/Shop/Bags/Shoulder_Bags?level3Filter=Chain_Strap&category=82',
        'http://www.net-a-porter.com/Shop/Bags/Shoulder_Bags?level3Filter=Cross_Body&category=82',
        'http://www.net-a-porter.com/Shop/Bags/Shoulder_Bags?level3Filter=Drawstring&category=82',
        'http://www.net-a-porter.com/Shop/Bags/Shoulder_Bags?level3Filter=Structured&category=82',
        'http://www.net-a-porter.com/Shop/Lingerie/Bodysuits?level3Filter=Bodysuits&category=350',
        'http://www.net-a-porter.com/Shop/Lingerie/Bras?level3Filter=Balconette_Bras&category=124',
        'http://www.net-a-porter.com/Shop/Lingerie/Bras?level3Filter=Contour_Bras&category=124',
        'http://www.net-a-porter.com/Shop/Lingerie/Bras?level3Filter=DD_Plus_Bras&category=124',
        'http://www.net-a-porter.com/Shop/Lingerie/Bras?level3Filter=Multiway_Bras&category=124',
        'http://www.net-a-porter.com/Shop/Lingerie/Bras?level3Filter=Maternity&category=320',
        'http://www.net-a-porter.com/Shop/Lingerie/Bras?level3Filter=Plunge_Bras&category=124',
        'http://www.net-a-porter.com/Shop/Lingerie/Bras?level3Filter=Push_Up_Bras&category=124',
        'http://www.net-a-porter.com/Shop/Lingerie/Bras?level3Filter=Soft_Cup_Bras&category=124',
        'http://www.net-a-porter.com/Shop/Lingerie/Bras?level3Filter=Strapless_Bras&category=124',
        'http://www.net-a-porter.com/Shop/Lingerie/Bras?level3Filter=Underwired_Bras&category=124',
        'http://www.net-a-porter.com/Shop/Lingerie/Briefs?level3Filter=Briefs&category=121',
        'http://www.net-a-porter.com/Shop/Lingerie/Briefs?level3Filter=Thongs&category=121',
        'http://www.net-a-porter.com/Shop/Lingerie/Corsetry?level3Filter=Corsets&category=130',
        'http://www.net-a-porter.com/Shop/Lingerie/Camisoles_and_Chemises?level3Filter=Camisoles&category=123',
        'http://www.net-a-porter.com/Shop/Lingerie/Camisoles_and_Chemises?level3Filter=Chemises&category=123',
        'http://www.net-a-porter.com/Shop/Lingerie/Camisoles_and_Chemises?level3Filter=Slips&category=123',
        'http://www.net-a-porter.com/Shop/Lingerie/Hosiery?level3Filter=Socks&category=116',
        'http://www.net-a-porter.com/Shop/Lingerie/Hosiery?level3Filter=Tights&category=114',
        'http://www.net-a-porter.com/Shop/Lingerie/Hosiery?level3Filter=Stockings&category=115',
        'http://www.net-a-porter.com/Shop/Lingerie/Lingerie_Accessories?level3Filter=Accessories&category=123',
        'http://www.net-a-porter.com/Shop/Lingerie/Shapewear?level3Filter=Light_Control&category=129',
        'http://www.net-a-porter.com/Shop/Lingerie/Shapewear?level3Filter=Bodysuits&category=129',
        'http://www.net-a-porter.com/Shop/Lingerie/Shapewear?level3Filter=Medium_Control&category=129',
        'http://www.net-a-porter.com/Shop/Lingerie/Shapewear?level3Filter=Firm_Control&category=129',
        'http://www.net-a-porter.com/Shop/Lingerie/Shapewear?level3Filter=Briefs_and_Shorts&category=129',
        'http://www.net-a-porter.com/Shop/Lingerie/Shapewear?level3Filter=Slips&category=129',
        'http://www.net-a-porter.com/Shop/Lingerie/Robes?level3Filter=Short_Robes&category=128',
        'http://www.net-a-porter.com/Shop/Lingerie/Robes?level3Filter=Long_Robes&category=128',
        'http://www.net-a-porter.com/Shop/Lingerie/Sleepwear?level3Filter=Nightdresses&category=126',
        'http://www.net-a-porter.com/Shop/Lingerie/Sleepwear?level3Filter=Pajamas&category=126',
        'http://www.net-a-porter.com/Shop/Lingerie/Sleepwear?level3Filter=Playsuits&category=154',
        'http://www.net-a-porter.com/Shop/Lingerie/Sleepwear?level3Filter=Sets&category=126',
        'http://www.net-a-porter.com/Shop/Clothing/Coats?level3Filter=Short&category=41',
        'http://www.net-a-porter.com/Shop/Clothing/Coats?level3Filter=Long&category=40',
        'http://www.net-a-porter.com/Shop/Clothing/Coats?level3Filter=Trench_Coats&category=43',
        'http://www.net-a-porter.com/Shop/Clothing/Coats?level3Filter=Leather&category=345',
        'http://www.net-a-porter.com/Shop/Clothing/Coats?level3Filter=Parkas&category=45',
        'http://www.net-a-porter.com/Shop/Clothing/Activewear?level3Filter=Jackets&category=47',
        'http://www.net-a-porter.com/Shop/Clothing/Activewear?level3Filter=Leggings&category=113',
        'http://www.net-a-porter.com/Shop/Clothing/Activewear?level3Filter=Shorts&category=165',
        'http://www.net-a-porter.com/Shop/Clothing/Activewear?level3Filter=Sports_Bras&category=124',
        'http://www.net-a-porter.com/Shop/Clothing/Activewear?level3Filter=Sweatshirts_and_Hoodies&category=8',
        'http://www.net-a-porter.com/Shop/Clothing/Activewear?level3Filter=Tops&category=158',
        'http://www.net-a-porter.com/Shop/Clothing/Activewear?level3Filter=Track_Pants&category=17',
        'http://www.net-a-porter.com/Shop/Lingerie/Suspender_Belts?level3Filter=Suspender_Belts&category=109',
        'http://www.net-a-porter.com/Shop/Clothing/Beachwear?level3Filter=One-Piece&category=36',
        'http://www.net-a-porter.com/Shop/Clothing/Beachwear?level3Filter=Bikinis&category=132',
        'http://www.net-a-porter.com/Shop/Clothing/Beachwear?level3Filter=Bandeau_Bikinis&category=132',
        'http://www.net-a-porter.com/Shop/Clothing/Beachwear?level3Filter=Halter_Bikinis&category=132',
        'http://www.net-a-porter.com/Shop/Clothing/Beachwear?level3Filter=Triangle_Bikinis&category=132',
        'http://www.net-a-porter.com/Shop/Clothing/Beachwear?level3Filter=Bikini_Separates&category=132',
        'http://www.net-a-porter.com/Shop/Clothing/Beachwear?level3Filter=Coverups&category=132',
        'http://www.net-a-porter.com/Shop/Clothing/Beachwear?level3Filter=Kaftans_and_Sarongs&category=133',
        'http://www.net-a-porter.com/Shop/Clothing/Beachwear?level3Filter=Beach_Dresses&category=133',
        'http://www.net-a-porter.com/Shop/Clothing/Beachwear?level3Filter=Shorts_and_Pants&category=132',
        'http://www.net-a-porter.com/Shop/Clothing/Beachwear?level3Filter=Jumpsuits_and_Playsuits&category=132',
        'http://www.net-a-porter.com/Shop/Clothing/Jackets?level3Filter=Biker_Jackets&category=47',
        'http://www.net-a-porter.com/Shop/Clothing/Jackets?level3Filter=Blazers&category=52',
        'http://www.net-a-porter.com/Shop/Clothing/Jackets?level3Filter=Capes&category=56',
        'http://www.net-a-porter.com/Shop/Clothing/Jackets?level3Filter=Casual_Jackets&category=49',
        'http://www.net-a-porter.com/Shop/Clothing/Jackets?level3Filter=Evening&category=47',
        'http://www.net-a-porter.com/Shop/Clothing/Jackets?level3Filter=Smart&category=47',
        'http://www.net-a-porter.com/Shop/Clothing/Jackets?level3Filter=Vests_and_Gilets&category=53',
        'http://www.net-a-porter.com/Shop/Clothing/Jackets?level3Filter=Bomber&category=47',
        'http://www.net-a-porter.com/Shop/Clothing/Jackets?level3Filter=Denim&category=51',
        'http://www.net-a-porter.com/Shop/Clothing/Jackets?level3Filter=Leather&category=50',
        'http://www.net-a-porter.com/Shop/Clothing/Jackets?level3Filter=Printed&category=47',
        'http://www.net-a-porter.com/Shop/Clothing/Jackets?level3Filter=Tailored&category=52',
        'http://www.net-a-porter.com/Shop/Clothing/Dresses?level3Filter=Mini&category=148',
        'http://www.net-a-porter.com/Shop/Clothing/Dresses?level3Filter=Knee_Length&category=148',
        'http://www.net-a-porter.com/Shop/Clothing/Dresses?level3Filter=Midi&category=148',
        'http://www.net-a-porter.com/Shop/Clothing/Dresses?level3Filter=Maxi&category=146',
        'http://www.net-a-porter.com/Shop/Clothing/Dresses?level3Filter=Gowns&category=127',
        'http://www.net-a-porter.com/Shop/Clothing/Dresses?level3Filter=Evening&category=352',
        'http://www.net-a-porter.com/Shop/Clothing/Dresses?level3Filter=Work&category=144',
        'http://www.net-a-porter.com/Shop/Clothing/Dresses?level3Filter=Off_Duty&category=144',
        'http://www.net-a-porter.com/Shop/Clothing/Dresses?level3Filter=Vacation&category=144',
        'http://www.net-a-porter.com/Shop/Clothing/Dresses?level3Filter=Long_Sleeved&category=144',
        'http://www.net-a-porter.com/Shop/Clothing/Dresses?level3Filter=Bridal&category=135',
        'http://www.net-a-porter.com/Shop/Clothing/Jeans?level3Filter=Boyfriend&category=339',
        'http://www.net-a-porter.com/Shop/Clothing/Jeans?level3Filter=Flared&category=25',
        'http://www.net-a-porter.com/Shop/Clothing/Jeans?level3Filter=Skinny_Leg&category=26',
        'http://www.net-a-porter.com/Shop/Clothing/Jeans?level3Filter=Straight_Leg&category=23',
        'http://www.net-a-porter.com/Shop/Clothing/Jeans?level3Filter=Cropped&category=22',
        'http://www.net-a-porter.com/Shop/Clothing/Jeans?level3Filter=High_Rise&category=342',
        'http://www.net-a-porter.com/Shop/Clothing/Jeans?level3Filter=Mid_Rise&category=342',
        'http://www.net-a-porter.com/Shop/Clothing/Jeans?level3Filter=Low_Rise&category=35',
        'http://www.net-a-porter.com/Shop/Clothing/Jeans?level3Filter=Coated&category=35',
        'http://www.net-a-porter.com/Shop/Clothing/Jumpsuits?level3Filter=Full_Length&category=154',
        'http://www.net-a-porter.com/Shop/Clothing/Jumpsuits?level3Filter=Playsuits&category=154',
        'http://www.net-a-porter.com/Shop/Clothing/Jumpsuits?level3Filter=Overalls&category=154',
        'http://www.net-a-porter.com/Shop/Clothing/Knitwear?level3Filter=Fine_Knit&category=6',
        'http://www.net-a-porter.com/Shop/Clothing/Knitwear?level3Filter=Medium_Knit&category=6',
        'http://www.net-a-porter.com/Shop/Clothing/Knitwear?level3Filter=Heavy_Knit&category=6',
        'http://www.net-a-porter.com/Shop/Clothing/Knitwear?level3Filter=Cardigan&category=7',
        'http://www.net-a-porter.com/Shop/Clothing/Knitwear?level3Filter=Sweater&category=6',
        'http://www.net-a-porter.com/Shop/Clothing/Knitwear?level3Filter=Cashmere&category=6',
        'http://www.net-a-porter.com/Shop/Clothing/Knitwear?level3Filter=Patterned&category=6',
        'http://www.net-a-porter.com/Shop/Clothing/Shorts?level3Filter=Short_and_Mini&category=18',
        'http://www.net-a-porter.com/Shop/Clothing/Shorts?level3Filter=Knee_Length&category=18',
        'http://www.net-a-porter.com/Shop/Clothing/Shorts?level3Filter=Denim&category=338',
        'http://www.net-a-porter.com/Shop/Clothing/Shorts?level3Filter=Leather&category=18',
        'http://www.net-a-porter.com/Shop/Clothing/Skirts?level3Filter=Mini&category=15',
        'http://www.net-a-porter.com/Shop/Clothing/Skirts?level3Filter=Knee_Length&category=15',
        'http://www.net-a-porter.com/Shop/Clothing/Skirts?level3Filter=Midi&category=15',
        'http://www.net-a-porter.com/Shop/Clothing/Skirts?level3Filter=Maxi&category=15',
        'http://www.net-a-porter.com/Shop/Clothing/Skirts?level3Filter=Leather&category=15',
        'http://www.net-a-porter.com/Shop/Clothing/Skirts?level3Filter=Pencil&category=15',
        'http://www.net-a-porter.com/Shop/Clothing/Skirts?level3Filter=Statement&category=15',
        'http://www.net-a-porter.com/Shop/Clothing/Skirts?level3Filter=Tailored&category=15',
        'http://www.net-a-porter.com/Shop/Clothing/Skirts?level3Filter=Bridal&category=15',
        'http://www.net-a-porter.com/Shop/Clothing/Pants?level3Filter=Leggings&category=113',
        'http://www.net-a-porter.com/Shop/Clothing/Pants?level3Filter=Skinny_Leg&category=17',
        'http://www.net-a-porter.com/Shop/Clothing/Pants?level3Filter=Straight_Leg&category=17',
        'http://www.net-a-porter.com/Shop/Clothing/Pants?level3Filter=Tapered&category=17',
        'http://www.net-a-porter.com/Shop/Clothing/Pants?level3Filter=Wide_Leg&category=17',
        'http://www.net-a-porter.com/Shop/Clothing/Pants?level3Filter=Culottes&category=17',
        'http://www.net-a-porter.com/Shop/Clothing/Pants?level3Filter=Cropped&category=17',
        'http://www.net-a-porter.com/Shop/Clothing/Pants?level3Filter=Leather&category=17',
        'http://www.net-a-porter.com/Shop/Clothing/Pants?level3Filter=Tailored&category=17',
        'http://www.net-a-porter.com/Shop/Clothing/Tops?level3Filter=Sleeveless&category=1',
        'http://www.net-a-porter.com/Shop/Clothing/Tops?level3Filter=Short_Sleeved&category=2',
        'http://www.net-a-porter.com/Shop/Clothing/Tops?level3Filter=Long_Sleeved&category=3',
        'http://www.net-a-porter.com/Shop/Clothing/Tops?level3Filter=Bodysuits&category=350',
        'http://www.net-a-porter.com/Shop/Clothing/Tops?level3Filter=Blouses&category=10',
        'http://www.net-a-porter.com/Shop/Clothing/Tops?level3Filter=Cropped&category=14',
        'http://www.net-a-porter.com/Shop/Clothing/Tops?level3Filter=Shirts&category=10',
        'http://www.net-a-porter.com/Shop/Clothing/Tops?level3Filter=Sweatshirts&category=9',
        'http://www.net-a-porter.com/Shop/Clothing/Tops?level3Filter=T-Shirts&category=2',
        'http://www.net-a-porter.com/Shop/Clothing/Tops?level3Filter=Tanks_and_Camis&category=1',
        'http://www.net-a-porter.com/Shop/Clothing/Tops?level3Filter=Tunics&category=5',
        'http://www.net-a-porter.com/Shop/Clothing/Tops?level3Filter=Leather&category=14',
        'http://www.net-a-porter.com/Shop/Clothing/Tops?level3Filter=Printed&category=14',
        'http://www.net-a-porter.com/Shop/Beauty/Fragrance&category=117',
        'http://www.net-a-porter.com/Shop/Beauty/Cosmetics_Cases&category=118'].each do |link|
        FashionCrawler::Models::Resource.create({
          url: link,
          task: 'NetAPorterProcessAtCatePage',
          is_visited: false,
          site_name: 'NetAPorter',
          store: FashionCrawler::Models::Store.find_by(name: 'NetAPorter')
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

    class NetAPorterProcessAtCatePage
      def self.execute(url, body)
        doc = Nokogiri::HTML(body)
        begin
          category = url.scan(/&category=(\d+)/).join('')
          doc.xpath("//*[@id='product-list']//a").each do |link|
            if link['href'].present?
              detail_url = "http://www.net-a-porter.com#{link['href']}?tmp=#{category}"
              #puts "!!!!!!!!!!!!!!!!!!!!!#{detail_url}!!!!!!!!!!!!!!!!!!!!!"
              unless FashionCrawler::Models::Resource.where(url: detail_url).exists?
                FashionCrawler::Models::Resource.create({
                url: detail_url,
                task: 'NetAPorterProcessAtDetailPage',
                is_visited: false,
                site_name: 'NetAPorter',
                store: FashionCrawler::Models::Store.find_by(name: 'NetAPorter')
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

    class NetAPorterProcessAtDetailPage
      def self.execute(url, body)
        doc = Nokogiri::HTML(body)
        begin
          #puts "===================================="
          url2 = url.gsub(/\?tmp=(.)*/, "")
          product = FashionCrawler::Models::Item.where(link: url2).first
          if product.nil?
            item = FashionCrawler::Models::Item.new
            item.link = url2
            name = doc.at_xpath("//h1[@itemprop='name']")
            item.name = name.text.strip unless name.nil?
            brand = doc.at_xpath("//a[@itemprop='name']")
            unless brand.nil?
              brand = brand.text.strip
              master_brand = MasterBrand.by_brand_name(brand)
              item.brand_id = master_brand.brand_id
              item.brand_name = MasterBrand.id_is_other?(item.brand_id) ? brand : master_brand.brand_name
              item.brand_name_ja = master_brand.brand_name_ja
            end
            item.site_id = 13
            item.site_name = "NetAPorter"
            item.country_name = "US"
          else
            item = product
          end

          description = doc.at_xpath("//*[@class='tabBody1 tabContent']")
          item.description = description.text.strip unless description.nil?

          price = doc.at_xpath("//*[@itemprop='price']")
          if price.nil?
            price = doc.at_xpath("//*[@class='price']")
          else
            base_price = doc.at_xpath("//*[@class='old-price']/span[2]")
            unless base_price.nil?
              puts item.original_base_price = base_price.text.strip
              base_price = item.original_base_price.gsub(/,(.)*/, "").gsub(".", "")
              puts item.base_price = CurrencyRate.convert_price_to_yen("EUR", base_price, "€")
            end
          end

          unless price.nil?
            item.original_price = price.text.strip
            item.price = CurrencyRate.convert_price_to_yen("USD", item.original_price, "$")
          end

          image_nodes = []
          doc.xpath("//*[@id='thumbnails-container']//meta").each do |link|
            image_nodes << link['content']
          end
          item.images = image_nodes.join(",")

          category = url.scan(/(\?tmp=(.)+)/).join('')
          category = category.gsub("?tmp=","")[0..-2]

          item.category_id = category.to_i
          master_category = MasterCategory.by_category_3_id(item.category_id.to_i)
          unless master_category.nil?
            item.category_name = master_category.category_3
            general_category_id = master_category.general_category_id
          end

          sizes = []
          doc.xpath("//*[@id='choose-your-size']//option").each do |node|
            size = node.text.strip
            if !size.match("Choose") && !sizes.include?(size)
              sizes << size.gsub("- sold out", "").gsub(/\s|\n/, "").gsub(/-only(.)*/, "")
            end
          end
          unless sizes.empty?
            puts item.original_size = sizes.join(",")
            if general_category_id.nil?
              item.size = item.original_size
            else
              item.size = MasterSize.convert_sizes(item.original_size, "US", general_category_id)
            end
          end

          #### Stock information
          total_items = 0
          doc.xpath("//div[@id='choose-your-size']//li").each do |size|
            next if size.text.match(/sold out/)
            num_of_items = size.text.split('-').last.scan(/\d+/).join('').to_i
            if num_of_items == 0 || !size.text.match(/-/)
              total_items = total_items + 3
            else
              total_items = total_items + num_of_items
            end
          end

          if total_items > 0
            item.flag = 1
            item.number_of_products = total_items
          else
            item.flag = 0
            item.number_of_products = 0
          end

          item.added_or_updated = true
          if !item.name.blank? && !item.brand_name.blank? && !item.price.blank? && item.flag == 1
            item.save!
            puts "added #{item.link}"
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
