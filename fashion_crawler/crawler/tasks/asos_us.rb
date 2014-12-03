# encoding: utf-8
require 'nokogiri'
require 'unicode'
require 'uri'
require 'date'
require 'open-uri'

module FashionCrawler
  module Tasks
    class AsosusProcessAtMainPage
      def self.execute(url, body)
        begin
          list_cate = ["http://us.asos.com/Men-Bags-Backpacks/wypes/?cid=12888&category=223"]
          # list_cate = ["http://us.asos.com/Men-Bags-Backpacks/wypes/?cid=12888&category=223",
          # "http://us.asos.com/Men-Bags-Barrel-Bag/ytkv7/?cid=13242&category=83",
          # "http://us.asos.com/Men-Bags-Duffle-Bag/y3clp/?cid=13241&category=83",
          # "http://us.asos.com/Men-Bags-Holdall/ytk4z/?cid=13239&category=349",
          # "http://us.asos.com/Men-Bags-Messenger-Bags/ytjx4/?cid=13238&category=220",
          # "http://us.asos.com/Men-Bags-Satchel/w5epd/?cid=13240&category=82",
          # "http://us.asos.com/Men-Bags-Shopper-Bags/x7152/?cid=13128&category=77",
          # "http://us.asos.com/Men-Underwear-Socks/rst6t/?cid=4030&WT.ac=CP|MW|gifts|hdr|underwear&category=246",
          # "http://us.asos.com/Men-Accessories-Belts/s0y7f/?cid=6474&category=247",
          # "http://us.asos.com/Men-Accessories-Caps-Hats/s0y9b/?cid=6517&category=240",
          # "http://us.asos.com/Men-Accessories-Gloves/t94rh/?cid=11854&category=244",
          # "http://us.asos.com/Men-Accessories-Scarves/s0ya1/?cid=6518&category=243",
          # "http://us.asos.com/Men-Accessories-Ties/s0y8d/?cid=6520&category=249",
          # "http://us.asos.com/Men-Accessories-Wallets/s0y6h/?cid=6516&category=233",
          # "http://us.asos.com/Men-Accessories/rst14/?cid=4210&category=247",
          # "http://us.asos.com/Men-Hoodies-Sweatshirts/tcokt/?cid=5668&category=170",
          # "http://us.asos.com/Men-Accessories-Belts/s0y7f/?cid=6474&category=247",
          # "http://us.asos.com/Men-Accessories-Caps-Hats/s0y9b/?cid=6517&category=240",
          # "http://us.asos.com/Men-Accessories-Gloves/t94rh/?cid=11854&category=244",
          # "http://us.asos.com/Men-Accessories-Scarves/s0ya1/?cid=6518&category=243",
          # "http://us.asos.com/Men-Accessories-Ties/s0y8d/?cid=6520&category=249",
          # "http://us.asos.com/Men-Accessories-Wallets/s0y6h/?cid=6516&category=233",
          # "http://us.asos.com/Men-Jackets-Coats-Baseball-Jackets/try2x/?cid=11907&category=197",
          # "http://us.asos.com/Men-Jackets-Coats-Quilted-Jackets/w075c/?cid=12050&category=196",
          # "http://us.asos.com/Men-Jackets-Coats-Parkas/vxu5h/?cid=12931&category=205",
          # "http://us.asos.com/Men-Jackets-Coats-Bomber-Jackets/12nvj5/?cid=16245&category=196",
          # "http://us.asos.com/Men-Jackets-Coats-Blazers/wo1g1/?cid=11903&category=200",
          # "http://us.asos.com/Men-Jackets-Coats-Wool-Coats/vjh8h/?cid=12456&category=204",
          # "http://us.asos.com/Men-Leather-Jackets/svyyo/?cid=11760&category=198",
          # "http://us.asos.com/Men-Jackets-Coats-Denim-Jackets/v2zo0/?cid=11908&category=199",
          # "http://us.asos.com/Men-Jackets-Coats-Gilets/xkuk3/?cid=14886&category=207",
          # "http://us.asos.com/Men-Jewelry-Bracelets/109b04/?cid=13835&category=228",
          # "http://us.asos.com/Men-Accessories-Cufflinks/13astd/?cid=16334&category=250",
          # "http://us.asos.com/Men-Jewelry-Earrings/12opzc/?cid=13837&category=229",
          # "http://us.asos.com/Men-Jewelry-Necklaces/wgj8k/?cid=13836&category=227",
          # "http://us.asos.com/Men-Jewelry-Rings/108gv1/?cid=13834&category=229",
          # "http://us.asos.com/Men/Jewellery/Shirt-Accessories/Cat/pgecategory.aspx?cid=17545&category=170",
          # "http://us.asos.com/Men-Watches/rst4y/?cid=5034&category=231",
          # "http://us.asos.com/Men-Underwear-Socks-Onesies/100hj6/?cid=16714&category=246",
          # "http://us.asos.com/Men-A-To-Z-Of-Brands-Diesel-Diesel-Jeans/tn8hx/?cid=11790&category=187",
          # "http://us.asos.com/Men/A-To-Z-Of-Brands/asos/asos-Jeans/Cat/pgecategory.aspx?cid=17101&category=187",
          # "http://us.asos.com/Men-Jeans/rssv7/?cid=4208&via=top#state=Rf-400%3D12840&parentID=Rf-400&pge=0&pgeSize=20&sort=-1&category=182",
          # "http://us.asos.com/Men/A-To-Z-Of-Brands/Nudie/Nudie-Jeans/Cat/pgecategory.aspx?cid=11864&category=182",
          # "http://us.asos.com/Men-Jeans-Slim-Jeans/sqxac/?cid=5054&category=182",
          # "http://us.asos.com/Men-Jeans-Straight-Jeans/s0wcz/?cid=5052&category=180",
          # "http://us.asos.com/Men-Jeans-Skinny-Jeans/s0wb1/?cid=5403&category=182",
          # "http://us.asos.com/Men-Jeans-Super-Skinny-Jeans/108zwf/?cid=16463&category=182",
          # "http://us.asos.com/Men-Jeans-Bootcut-Jeans/s0wft/?cid=5053&category=179",
          # "http://us.asos.com/Men-Jeans-Tapered-Jeans/108hmi/?cid=16982&category=184",
          # "http://us.asos.com/Men-Jackets-Coats-Denim-Jackets/v2zo0/?cid=11908&category=199",
          # "http://us.asos.com/Men-Shirts-Denim-Shirts/x7bu0/?cid=13024&category=353",
          # "http://us.asos.com/Men-Shorts-Denim-Shorts/w4fkp/?cid=13138&category=188",
          # "http://us.asos.com/Men-T-Shirts-Long-Sleeve-T-Shirts/zguat/?cid=13084&category=167",
          # "http://us.asos.com/Men-Sweaters-Cardigans/rssrf/?cid=7617&category=174",
          # "http://us.asos.com/Men-Underwear-Socks-Loungewear/12j42h/?cid=18797&category=246",
          # "http://us.asos.com/Men-Shirts-Check-Shirts/wb6uu/?cid=12299&category=170",
          # "http://us.asos.com/Men-Shirts-Denim-Shirts/x7bu0/?cid=13024&category=170",
          # "http://us.asos.com/Men-Shirts-Oxford-Shirts/x2wrv/?cid=14478&category=170",
          # "http://us.asos.com/Men-Shirts-Printed-Shirts/wflr8/?cid=13803&category=170",
          # "http://us.asos.com/Men-Shirts-Short-Sleeve-Shirts/wflu2/?cid=13802&category=170",
          # "http://us.asos.com/Fashion-Online-6/Cat/pgecategory.aspx?cid=13510&WT.ac=CP|MW|shirts|head|shirts&CTAref=Cat_Header&category=170",
          # "http://us.asos.com/Men-Leather-Jackets/svyyo/?cid=11760&category=198",
          # "http://us.asos.com/Men-Shorts/w6b1z/?cid=7078&category=188",
          # "http://us.asos.com/Men-Suits-Blazers-Suit-Jackets/xq1r9/?cid=14998&WT.ac=CP|MW|suitsblazers|head|suitjackets&CTAref=Cat_Header&category=200",
          # "http://us.asos.com/Men-Suits-Blazers-Suit-Pants/xpyyv/?cid=14999&WT.ac=CP|MW|suitsblazers|head|suittrousers&CTAref=Cat_Header&category=200",
          # "http://us.asos.com/Men-Jackets-Coats-Blazers/wo1g1/?cid=11903&WT.ac=CP|MW|suitsblazers|head|blazers&CTAref=Cat_Header&category=200",
          # "http://us.asos.com/Men-Jackets-Coats-Vests/vwvfp/?cid=12287&WT.ac=CP|MW|suitsblazers|head|waistcoats&CTAref=Cat_Header&category=207",
          # "http://us.asos.com/Men-Pants-Chinos-Smart-Pants/12qpwe/?cid=14052&WT.ac=CP|MW|suitsblazers|head|smarttrousers&CTAref=Cat_Header&category=178",
          # "http://us.asos.com/Men-Suits-Blazers-Suits/wlzkw/?cid=14054&WT.ac=CP|MW|suitsblazers|head|suits&CTAref=Cat_Header&category=200",
          # "http://us.asos.com/Men-Suits-Blazers-Tuxedos/znp28/?cid=15597&WT.ac=CP|MW|suitsblazers|head|tuxedos&CTAref=Cat_Header&category=200",
          # "http://us.asos.com/Fashion-Online-10/Cat/pgecategory.aspx?cid=13517&WT.ac=CP|MW|suitsblazers|head|jersey&CTAref=Cat_Header&category=263",
          # "http://us.asos.com/Men-Suits-Blazers-Linen-Suits/13dhwd/?cid=19430&WT.ac=CP|MW|suitsblazers|head|linen&CTAref=Cat_Header&category=200",
          # "http://us.asos.com/Men-Sunglasses-Aviators/xq9wr/?cid=15055&WT.ac=CP|MW|sunglasses|head|aviators&CTAref=Cat_Header&category=237",
          # "http://us.asos.com/Men-Sunglasses-Clubmasters/10jhg1/?cid=15743&WT.ac=CP|MW|sunglasses|head|clubmasters&CTAref=Cat_Header&category=237",
          # "http://us.asos.com/Men/Sunglasses/Round-Sunglasses/Cat/pgecategory.aspx?cid=19271&WT.ac=CP|MW|sunglasses|head|round&CTAref=Cat_Header&category=237",
          # "http://us.asos.com/Men-Sunglasses-Wayfarers/xq75l/?cid=15054&WT.ac=CP|MW|sunglasses|head|wayfarers&CTAref=Cat_Header&category=237",
          # "http://us.asos.com/Men-A-To-Z-Of-Brands-Spitfire-Sunglasses/s15kd/?cid=3717&WT.ac=CP|MW|sunglasses|head|spitfire&CTAref=Cat_Header&category=237",
          # "http://us.asos.com/Men-A-To-Z-Of-Brands-Ray-Ban/so3z0/?cid=4497&WT.ac=CP|MW|sunglasses|head|rayban&CTAref=Cat_Header&category=237",
          # "http://us.asos.com/Men-A-To-Z-Of-Brands-Jeepers-Peepers/s13hl/?cid=4318&WT.ac=CP|MW|sunglasses|head|jeeperspeepers&CTAref=Cat_Header&category=237",
          # "http://us.asos.com/Men-Shoes-Boots-Sneakers-Flip-Flops/10jkiu/?cid=17514&category=213",
          # "http://us.asos.com/Men/Shoes-Boots-Trainers/Sandals/Cat/pgecategory.aspx?cid=6593&category=212",
          # "http://us.asos.com/Men-Shoes-Boots-Sneakers-Sneakers/wyhpe/?cid=5776&category=213",
          # "http://us.asos.com/Men-Shoes-Boots-Sneakers-Chelsea-Boots/11svlr/?cid=18695&category=213",
          # "http://us.asos.com/Men-Shoes-Boots-Sneakers-Boots/yh62a/?cid=5774&category=213",
          # "http://us.asos.com/Men-Shoes-Boots-Sneakers-Sneakers/sn045/?cid=5775&category=213",
          # "http://us.asos.com/Men-Shoes-Boots-Sneakers-Boat-Shoes/xplos/?cid=10315&category=217",
          # "http://us.asos.com/Men-Shoes-Boots-Sneakers-Desert-Boots/1099z2/?cid=12040&category=213",
          # "http://us.asos.com/Men-Shoes-Boots-Sneakers-Loafers/10adbx/?cid=11247&category=213",
          # "http://us.asos.com/Men-Shoes-Boots-Sneakers-Chukka-Boots/1092k4/?cid=11575&category=213",
          # "http://us.asos.com/Men-Shoes-Boots-Sneakers-Smart/s0x9c/?cid=5773&category=213",
          # "http://us.asos.com/Men-Shoes-Boots-Sneakers-Brogues-Derbies/y9ijb/?cid=11941&category=213",
          # "http://us.asos.com/Men-Swimwear/w4fqc/?cid=13210&category=260",
          # "http://us.asos.com/Men-Underwear-Socks/rst6t/?cid=4030&category=246",
          # "http://us.asos.com/Men-T-Shirts-Tanks-Print/sn0bi/?cid=9172&WT.ac=CP|MW|tshirts|head|print&CTAref=Cat_Header&category=166",
          # "http://us.asos.com/Men-T-Shirts-Tanks-Plain/ssrlr/?cid=9171&WT.ac=CP|MW|tshirts|head|plain&CTAref=Cat_Header&category=166",
          # "http://us.asos.com/Men-T-Shirts-Tanks-Striped/sn5rg/?cid=9887&WT.ac=CP|MW|tshirts|head|striped&CTAref=Cat_Header&category=166",
          # "http://us.asos.com/Men-T-Shirts-Long-Sleeve-T-Shirts/107w2i/?cid=13084&WT.ac=CP|MW|tshirts|head|longsleeved&CTAref=Cat_Header&category=167",
          # "http://us.asos.com/Men/Sale/T-Shirts-Vests/Cat/pgecategory.aspx?cid=5232&category=166",
          # "http://us.asos.com/Men-Pants-Chinos/w3s1o/?cid=4910&category=178",
          # "http://us.asos.com/Men-Watches-Digital-Watches/sp1z0/?cid=11347&category=231",
          # "http://us.asos.com/Men-Watches-Sports-Watches/sqykr/?cid=11346&category=231",
          # "http://us.asos.com/Men-Watches-Chronograph-Watches/x5lij/?cid=14582&category=231",
          # "http://us.asos.com/Men-Watches-Designer-Watches/sqymm/?cid=11345&category=231",
          # "http://us.asos.com/Men/A-To-Z-Of-Brands/Emporio-Armani/Emporio-Armani-Watches/Cat/pgecategory.aspx?cid=11920&category=231",
          # "http://us.asos.com/Men-A-To-Z-Of-Brands-Casio/xnfcs/?cid=3735&category=231",
          # "http://us.asos.com/Men-Watches/rst4y/?cid=5034&category=231",
          # "http://us.asos.com/Men/Sale/Jewellery-Watches/Cat/pgecategory.aspx?cid=8199#state=Rf-100%3DWatches%2CUnisex%2BWatches&parentID=Rf-100&pge=0&pgeSize=20&sort=-1&category=231",
          # "http://us.asos.com/Men-T-Shirts-Tanks/11uq8r/?cid=9178&category=166",
          # "http://us.asos.com/Men-Polo-Shirts/rsspj/?cid=4616&category=168",
          # "http://us.asos.com/Women-Accessories-Belts/sn2z3/?cid=6448&WT.ac=CP|WW|accs|head|belts&CTAref=Cat_Header&category=109",
          # "http://us.asos.com/Women-Accessories-Gloves/wyfc7/?cid=11990&WT.ac=CP|WW|accs|head|gloves&CTAref=Cat_Header&category=108",
          # "http://us.asos.com/Women-Jewelry-Watches-Hair-Accessories/y96ni/?cid=11412&WT.ac=CP|WW|accs|head|hair&CTAref=Cat_Header&category=98",
          # "http://us.asos.com/Women-Accessories-Hats/umt2b/?cid=6449&WT.ac=CP|WW|accs|head|hats&CTAref=Cat_Header&category=103",
          # "http://us.asos.com/Women-Jewelry-Watches/x5dgw/?cid=4175&WT.ac=CP|WW|accs|head|jewellery&CTAref=Cat_Header&category=98",
          # "http://us.asos.com/Women-Gifts-For-Her/yqawl/?cid=16095&WT.ac=CP|WW|accs|head|gifts&CTAref=Cat_Header&category=141",
          # "http://us.asos.com/Women/Curve-Plus-Size/Belts/Cat/pgecategory.aspx?cid=16045&WT.ac=CP|WW|accs|head|plussizeaccs&CTAref=Cat_Header&category=109",
          # "http://us.asos.com/Women-Accessories-Scarves/sn36x/?cid=6452&WT.ac=CP|WW|accs|head|scarves&CTAref=Cat_Header&category=243",
          # "http://us.asos.com/women/petite/cat/Men/Trousers-Chinos/Sweat-Pants/Cat/pgecategory.aspx?cid=14274&category=34",
          # "http://us.asos.com/Women-Bags-Purses-Rucksacks/wvnv1/?cid=12496&category=84",
          # "http://us.asos.com/Women-Bags-Purses-Beach-Bags/xtch9/?cid=15122&category=85",
          # "http://us.asos.com/Women-Bags-Purses-Clutches/sn10c/?cid=11305&category=81",
          # "http://us.asos.com/Women-Bags-Purses-Cross-Body-Bags/xt7vp/?cid=15121&category=82",
          # "http://us.asos.com/Women-Bags-Purses-Designer-Handbags/sn1aj/?cid=11308&category=78",
          # "http://us.asos.com/Duffle-bags-Shop-womens-duffle-bags/sn4x5/?cid=11302&category=83",
          # "http://us.asos.com/Women-Bags-Purses-Leather-Bags/xtbrp/?cid=15130&category=85",
          # "http://us.asos.com/Women-Bags-Purses-Gadget-Accessories/109vox/?cid=14536&category=111",
          # "http://us.asos.com/Women-Bags-Purses-Purses/sn0y7/?cid=11304&category=86",
          # "http://us.asos.com/Women-Bags-Purses-Satchels/sn4v9/?cid=11022&category=78",
          # "http://us.asos.com/Women-Bags-Purses-Shoulder-Bags/sn243/?cid=11307&category=82",
          # "http://us.asos.com/Women-Bags-Purses-Travel-Bags/y6urn/?cid=15722&category=349",
          # "http://us.asos.com/Women/Co-Ords/Cat/pgecategory.aspx?cid=19632&category=37",
          # "http://us.asos.com/Women-Coats-Jackets-Blazers/104r6l/?cid=11896&category=52",
          # "http://us.asos.com/Women-Dresses-Denim-Dresses/10fh1c/?cid=17396&category=144",
          # "http://us.asos.com/Women-Coats-Jackets-Denim-Jackets/xtrv0/?cid=15151&category=51",
          # "http://us.asos.com/Women/Jumpsuits-Playsuits/Denim-Jumpsuits-Playsuits/Cat/pgecategory.aspx?cid=19060&category=154",
          # "http://us.asos.com/Women-Jeans-Denim-Shirts-Jackets/snxg6/?cid=11311&category=47",
          # "http://us.asos.com/Women-Shorts-Denim-Shorts/xracp/?cid=10851&category=338",
          # "http://us.asos.com/Women-Skirts-Denim-Skirts/xtc9x/?cid=15177&category=15",
          # "http://us.asos.com/Women-Jeans-Jeggings/12o822/?cid=19057&category=342",
          # "http://us.asos.com/Women/Dresses/Pinafores/Cat/pgecategory.aspx?cid=17938&category=15",
          # "http://us.asos.com/Women-Gifts-For-Her-Home-Accessories/11vjqo/?cid=18396&WT.ac=CP|WW|gifts|hdr|houseware&category=141",
          # "http://us.asos.com/Women/Gifts-For-Her/Stationery/Cat/pgecategory.aspx?cid=18397&WT.ac=CP|WW|gifts|hdr|stationery&category=141",
          # "http://us.asos.com/Women-Gifts-For-Her-Books/11shk9/?cid=18654&WT.ac=CP|WW|gifts|hdr|books&category=141",
          # "http://us.asos.com/Women-Lingerie-Sleepwear/rsrua/?cid=6046&WT.ac=CP|WW|gifts|hdr|nightwear&category=125",
          # "http://us.asos.com/Women-Beauty-Beauty-Gifts/wz6tj/?cid=14312&WT.ac=CP|WW|gifts|hdr|beauty&category=141",
          # "http://us.asos.com/Men-Gifts-For-Men/11o3aj/?cid=16091&WT.ac=CP|WW|gifts|hdr|4guys&category=141",
          # "http://us.asos.com/Women-Bags-Purses-Gadget-Accessories/109vox/?cid=14536&WT.ac=CP|WW|gifts|hdr|tech&category=111",
          # "http://us.asos.com/Women-Jewelry-Watches/x5dgw/?cid=4175&WT.ac=CP|WW|gifts|hdr|jewellery&category=98",
          # "http://us.asos.com/Women/Gifts-For-Her/Christmas-Gifts/50-Under-15/Cat/pgecategory.aspx?cid=14392&WT.ac=CP|WW|gifts|hdr|4you&category=141",
          # "http://us.asos.com/Women-Christmas-Gifts-Gifts-For-Girls/11z3yk/?cid=14461&WT.ac=CP|WW|gifts|hdr|bff&category=141",
          # "http://us.asos.com/Women-Christmas-Gifts-Secret-Santa/10by7p/?cid=16559&WT.ac=CP|WW|gifts|hdr|cheap&category=141",
          # "http://us.asos.com/Women-Jewelry-Watches-Body-Jewelry/120kaj/?cid=17824&WT.ac=CP|WW|jewellery|head|bodyjewellery&CTAref=Cat_Header&category=98",
          # "http://us.asos.com/Women-Jewelry-Watches-Bracelets/y9p54/?cid=11410&WT.ac=CP|WW|jewellery|head|bracelets&CTAref=Cat_Header&category=93",
          # "http://us.asos.com/Women-Jewelry-Watches-Earrings/xmxz0/?cid=11409&WT.ac=CP|WW|jewellery|head|earrings&CTAref=Cat_Header&category=91",
          # "http://us.asos.com/Women-Jewelry-Watches-Festival-Jewelry/xsr7n/?cid=13455&WT.ac=CP|WW|jewellery|head|festival&CTAref=Cat_Header&category=98",
          # "http://us.asos.com/Women-Jewelry-Watches-Friendship-Bracelets/xstmi/?cid=15118&WT.ac=CP|WW|jewellery|head|friendbracelet&CTAref=Cat_Header&category=93",
          # "http://us.asos.com/Women/Jewellery-Watches/Gold-Silver-Jewellery/Cat/pgecategory.aspx?cid=18829&WT.ac=CP|WW|jewellery|head|goldsilver&CTAref=Cat_Header&category=98",
          # "http://us.asos.com/Women-Jewelry-Watches-Hair-Accessories/y96ni/?cid=11412&WT.ac=CP|WW|jewellery|head|hairacc&CTAref=Cat_Header&category=98",
          # "http://us.asos.com/Women-Jewelry-Watches-Necklaces/xmyrf/?cid=11408&WT.ac=CP|WW|jewellery|head|necklaces&CTAref=Cat_Header&category=90",
          # "http://us.asos.com/Women-Jewelry-Watches-Rings/xsqv3/?cid=11407&WT.ac=CP|WW|jewellery|head|rings&CTAref=Cat_Header&category=98",
          # "http://us.asos.com/Women/Jewellery-Watches/Watches/Cat/pgecategory.aspx?cid=5088&WT.ac=CP|WW|jewellery|head|watches&CTAref=Cat_Header&category=98",
          # "http://us.asos.com/Women-Jeans-Bootcut-Jeans/soq1e/?cid=11310&WT.ac=CP|WW|jeans|head|bootcut&CTAref=Cat_Header&category=20",
          # "http://us.asos.com/Women-Jeans-Boyfriend-Jeans/snxi2/?cid=11309&WT.ac=CP|WW|jeans|head|boyfriend&CTAref=Cat_Header&category=339",
          # "http://us.asos.com/Women-Jeans-Dark-Wash-Jeans/snmhf/?cid=11314&WT.ac=CP|WW|jeans|head|darkwash&CTAref=Cat_Header&category=24",
          # "http://us.asos.com/Women-Jeans-Flare-Jeans/soq2c/?cid=11316&WT.ac=CP|WW|jeans|head|flare&CTAref=Cat_Header&category=25",
          # "http://us.asos.com/Women-Jeans-High-Waisted-Jeans/xtdpr/?cid=15159&WT.ac=CP|WW|jeans|head|highwaist&CTAref=Cat_Header&category=342",
          # "http://us.asos.com/Women-Jeans-Jeggings/12o822/?cid=19057&WT.ac=CP|WW|jeans|head|jeggings&CTAref=Cat_Header&category=342",
          # "http://us.asos.com/Women-Jeans-Printed-Jeans/yyb7r/?cid=16494&WT.ac=CP|WW|jeans|head|printed&CTAref=Cat_Header&category=28",
          # "http://us.asos.com/Women-Jeans-Skinny-Jeans/13d5im/?cid=10769&WT.ac=CP|WW|jenas|head|skinny&CTAref=Cat_Header&category=26",
          # "http://us.asos.com/Women-Jeans-Slim-Jeans/yusnc/?cid=15157&WT.ac=CP|WW|jeans|head|slim&CTAref=Cat_Header&category=26",
          # "http://us.asos.com/Women-Tops-Hoodies-Sweatshirts/z6jq0/?cid=11321&category=8",
          # "http://us.asos.com/Women-Tops-Bodies/sofaz/?cid=11323&category=350",
          # "http://us.asos.com/Women-Tops-Camis/xt18e/?cid=15202&category=123",
          # "http://us.asos.com/Women-Tops-Crop-Tops/xtr6n/?cid=15196&category=14",
          # "http://us.asos.com/Women-Tops-Long-Sleeve-Tops/100yb4/?cid=17334&category=3",
          # "http://us.asos.com/Women-Tops-Hoodies-Sweatshirts/z6jq0/?cid=11321&category=8",
          # "http://us.asos.com/Women-T-Shirts-Tanks/101vt4/?cid=4718&category=2",
          # "http://us.asos.com/Women-T-Shirts-Tanks-Jersey-Tops/zmfbu/?cid=11550&category=2",
          # "http://us.asos.com/Women/Jumpsuits-Playsuits/Denim-Jumpsuits-Playsuits/Cat/pgecategory.aspx?cid=19060&WT.ac=CP|WW|jumpsuits|head|denim&CTAref=Cat_Header&category=37",
          # "http://us.asos.com/Women-Jumpsuits-Playsuits-Dungarees/xtiuc/?cid=15167&WT.ac=CP|WW|jumpsuits|head|dungarees&CTAref=Cat_Header&category=37",
          # "http://us.asos.com/Women-Jumpsuits-Playsuits-Jumpsuits/xtcnw/?cid=15165&WT.ac=CP|WW|jumpsuits|head|jumpsuits&CTAref=Cat_Header&category=37",
          # "http://us.asos.com/Women-Jumpsuits-Playsuits-Onesies/z51lz/?cid=16718&WT.ac=CP|WW|jumpsuits|head|onesies&CTAref=Cat_Header&category=37",
          # "http://us.asos.com/Women-Jumpsuits-Playsuits-Playsuits/xt7ur/?cid=15166&WT.ac=CP|WW|jumpsuits|head|playsuits&CTAref=Cat_Header&category=37",
          # "http://us.asos.com/Women/Jumpsuits-Playsuits/Unitards/Cat/pgecategory.aspx?cid=17990&WT.ac=CP|WW|jumpsuits|head|unitards&CTAref=Cat_Header&category=37",
          # "http://us.asos.com/Women-Lingerie-Sleepwear-Bras/s0atn/?cid=6576&WT.ac=CP|WW|lingerie|head|bras&CTAref=Cat_Header&category=124",
          # "http://us.asos.com/Women-Lingerie-Sleepwear-Bodies/s0awh/?cid=7724&WT.ac=CP|WW|lingerie|head|bodies&CTAref=Cat_Header&category=125",
          # "http://us.asos.com/Women-Lingerie-Sleepwear-Corsets/s0axf/?cid=6574&WT.ac=CP|WW|lingerie|head|corsets&CTAref=Cat_Header&category=130",
          # "http://us.asos.com/Women-Lingerie-Sleepwear-Briefs/s0avj/?cid=6577&WT.ac=CP|WW|lingerie|head|briefs&CTAref=Cat_Header&category=121",
          # "http://us.asos.com/Women-Lingerie-Sleepwear-Lingerie-Sets/s0aul/?cid=6575&WT.ac=CP|WW|lingerie|head|sets&CTAref=Cat_Header&category=125",
          # "http://us.asos.com/Women-Maternity-Lingerie/s0bso/?cid=8622&WT.ac=CP|WW|lingerie|head|maternity&CTAref=Cat_Header&category=320",
          # "http://us.asos.com/Women-Lingerie-Sleepwear-Sleepwear/s0b0i/?cid=6578&WT.ac=CP|WW|lingerie|head|nightwear&CTAref=Cat_Header&category=126",
          # "http://us.asos.com/Women-Lingerie-Sleepwear-Pyjamas/115b0c/?cid=18099&WT.ac=CP|WW|lingerie|head|pyjamas&CTAref=Cat_Header&category=126",
          # "http://us.asos.com/Women-Lingerie-Sleepwear-Sexy-Lingerie/zr2in/?cid=17119&WT.ac=CP|WW|lingerie|head|sexylingerie&CTAref=Cat_Header&category=125",
          # "http://us.asos.com/Women-Lingerie-Sleepwear-Shapewear/s0ayd/?cid=6579&WT.ac=CP|WW|lingerie|head|shapewear&CTAref=Cat_Header&category=129",
          # "http://us.asos.com/Women-Lingerie-Sleepwear-Thongs/114dqm/?cid=18090&WT.ac=CP|WW|lingerie|head|thongs&CTAref=Cat_Header&category=121",
          # "http://us.asos.com/Women-Sweaters-Cardigans-Sweaters/xtcbl/?cid=15160&WT.ac=CP|WW|jumperscardi|head|jumpers&CTAref=Cat_Header&category=7",
          # "http://us.asos.com/Women-Dresses-Knitted-Dresses/ywdtc/?cid=12686&WT.ac=CP|WW|jumperscardi|head|knitdress&CTAref=Cat_Header&category=6",
          # "http://us.asos.com/Women-Sweaters-Cardigans-Cardigans/xtc8z/?cid=15161&WT.ac=CP|WW|jumperscardi|head|carigans&CTAref=Cat_Header&category=7",
          # "http://us.asos.com/Women-Tops-Kimonos/xtqqb/?cid=15198&category=156",
          # "http://us.asos.com/Women-Maternity-Dresses/s0bl2/?cid=8343&WT.ac=CP|WW|maternity|head|dresses&CTAref=Cat_Header&category=315",
          # "http://us.asos.com/Women-Maternity-Jeans/yspln/?cid=8345&WT.ac=CP|WW|maternity|head|jeans&CTAref=Cat_Header&category=314",
          # "http://us.asos.com/Women-Maternity-Jumpsuits-Playsuits/10isp8/?cid=13893&WT.ac=CP|WW|maternity|head|jumpsuits&CTAref=Cat_Header&category=154",
          # "http://us.asos.com/Women-Maternity-Lingerie/s0bso/?cid=8622&WT.ac=CP|WW|maternity|head|lingerie&CTAref=Cat_Header&category=320",
          # "http://us.asos.com/Women/Maternity/Maternity-Party-Dresses/Cat/pgecategory.aspx?cid=14551&WT.ac=CP|WW|maternity|head|partydress&CTAref=Cat_Header&category=315",
          # "http://us.asos.com/Women-Maternity-Skirts/y4vge/?cid=15095&WT.ac=CP|WW|maternity|head|skirts&CTAref=Cat_Header&category=15",
          # "http://us.asos.com/Women-Maternity-Tops/s0bow/?cid=8344&WT.ac=CP|WW|maternity|head|tops&CTAref=Cat_Header&category=313",
          # "http://us.asos.com/Women/Maternity/Trousers-Leggings/Cat/pgecategory.aspx?cid=17127&WT.ac=CP|WW|maternity|head|trousers&CTAref=Cat_Header&category=113",
          # "http://us.asos.com/Women-Tops-Evening-Tops/snlm5/?cid=11320&category=313",
          # "http://us.asos.com/Women-Tops-Sweatshirts/snsfd/?cid=11321&category=10",
          # "http://us.asos.com/Women-Tops-Tunics/w0zdq/?cid=12799&category=5",
          # "http://us.asos.com/Women-Tops-Shirts-Blouses/sn1j1/?cid=11318&category=10",
          # "http://us.asos.com/Women-T-Shirts-Tanks/rsrf5/?cid=4718&category=2",
          # "http://us.asos.com/Women-Tops-Tanks-Camis/xra77/?cid=12801&category=350",
          # "http://us.asos.com/Women-Tops-Printed-Tops/vuo6q/?cid=12800&category=14",
          # "http://us.asos.com/Women-Tops-Workwear/sn1kz/?cid=11319&category=14",
          # "http://us.asos.com/Women-Shorts-Culottes/11hugq/?cid=18419&category=18",
          # "http://us.asos.com/Women-Shorts-Denim-Shorts/xracp/?cid=10851&category=338",
          # "http://us.asos.com/Women-Shorts-Leather-Shorts/xraid/?cid=10848&category=18",
          # "http://us.asos.com/Women-Shorts-Hot-Pants/xtbpt/?cid=15175&category=17",
          # "http://us.asos.com/Women/Shorts/Skorts/Cat/pgecategory.aspx?cid=19054&category=18",
          # "http://us.asos.com/Women-Shorts-Tailored-Shorts/1106cy/?cid=17428&category=18",
          # "http://us.asos.com/Women-Petite-Outerwear/s0beh/?cid=8353&WT.ac=CP|WW|petite|head|coats&CTAref=Cat_Header&category=47",
          # "http://us.asos.com/Women-Petite-Dresses/s0bcl/?cid=8350&WT.ac=CP|WW|petite|head|dresses&CTAref=Cat_Header&category=144",
          # "http://us.asos.com/Women-Petite-Jumpsuits-Playsuits/x8902/?cid=13894&WT.ac=CP|WW|petite|head|jumpsuits&CTAref=Cat_Header&category=154",
          # "http://us.asos.com/Women-Petite-Skirts-Shorts/x2cg3/?cid=12247&WT.ac=CP|WW|petite|head|skirts&CTAref=Cat_Header&category=15",
          # "http://us.asos.com/Women-Petite-Pants-Leggings/10bp7y/?cid=17151&WT.ac=CP|WW|petite|head|trousers&CTAref=Cat_Header&category=113",
          # "http://us.asos.com/Women-Petite-Tops/s0bdj/?cid=8352&WT.ac=CP|WW|petite|head|tops&CTAref=Cat_Header&category=14",
          # "http://us.asos.com/Women-Socks-Tights-Ankle-Socks/xtk16/?cid=15186&category=114",
          # "http://us.asos.com/Women-Socks-Tights-Knee-Socks/xtdqp/?cid=15185&category=114",
          # "http://us.asos.com/Women/Socks-Tights/Novelty-Socks/Cat/pgecategory.aspx?cid=18130&category=114",
          # "http://us.asos.com/Women-Socks-Tights-Socks/xt5vr/?cid=15184&category=114",
          # "http://us.asos.com/Women-Socks-Tights-Tights/xtbxd/?cid=15183&category=114",
          # "http://us.asos.com/Women-Shoes-Ballet-Pumps/wsk27/?cid=13685&category=64",
          # "http://us.asos.com/Women-Shoes-Boots/s07bv/?cid=6455&category=69",
          # "http://us.asos.com/Women-Shoes-Flat-Sandals/zrl7t/?cid=17170&category=58",
          # "http://us.asos.com/Women-Shoes-Flat-Shoes/s07dr/?cid=6459&category=64",
          # "http://us.asos.com/Women-Shoes-Heeled-Sandals/zre1e/?cid=17169&category=58",
          # "http://us.asos.com/Women-Shoes-Heels/s0797/?cid=6461&category=62",
          # "http://us.asos.com/Women-Shoes-Platform-Shoes/wsr4v/?cid=14208&category=67",
          # "http://us.asos.com/Women-Shoes-Pointed-Shoes/zreou/?cid=17168&category=67",
          # "http://us.asos.com/Women-Shoes-Shoe-Accessories/zwlex/?cid=17212&category=67",
          # "http://us.asos.com/Women-Shoes-Sneakers/s07ep/?cid=6456&category=59",
          # "http://us.asos.com/Women-Shoes-Wedges/s07ax/?cid=10266&category=63",
          # "http://us.asos.com/Women-Shoes-Wellies/yiqup/?cid=15171&category=67",
          # "http://us.asos.com/Women-Skirts-Denim-Skirts/xtc9x/?cid=15177&category=15",
          # "http://us.asos.com/Women-Skirts-High-Waist-Skirts/xtdrn/?cid=15181&category=15",
          # "http://us.asos.com/Women-Skirts-Leather-Skirts/ynsuc/?cid=16167&category=15",
          # "http://us.asos.com/Women-Skirts-Maxi-Skirts/vxond/?cid=12910&category=15",
          # "http://us.asos.com/Women-Skirts-Pencil-Skirts/vxabh/?cid=12909&category=15",
          # "http://us.asos.com/Women-Skirts-Pleated-Skirts/xtck3/?cid=15182&category=15",
          # "http://us.asos.com/Women-Skirts-Skater-Skirts/12dfso/?cid=17431&category=15",
          # "http://us.asos.com/Women/Shorts/Skorts/Cat/pgecategory.aspx?cid=19054&category=18",
          # "http://us.asos.com/Women-Skirts-Tube-Skirts/xtci7/?cid=15178&category=15",
          # "http://us.asos.com/Women/Co-Ords/Cat/pgecategory.aspx?cid=19632&WT.ac=CP|WW|suits|head|coords&CTAref=Cat_Header&category=39",
          # "http://us.asos.com/Suits-Separates/Suit-Dresses/Cat/pgecategory.aspx?cid=15190&WT.ac=CP|WW|suits|head|suitdresses&CTAref=Cat_Header&category=154",
          # "http://us.asos.com/Suits-Separates/Suit-Jackets/Cat/pgecategory.aspx?cid=15188&WT.ac=CP|WW|suits|head|suitjackets&CTAref=Cat_Header&category=47",
          # "http://us.asos.com/Suits-Separates/Suit-Skirts/Cat/pgecategory.aspx?cid=15189&WT.ac=CP|WW|suits|head|suitskirts&CTAref=Cat_Header&category=15",
          # "http://us.asos.com/Women-Suits-Separates-Suit-Pants/12o9f2/?cid=15187&WT.ac=CP|WW|suits|head|suittrousers&CTAref=Cat_Header&category=17",
          # "http://us.asos.com/Women-Swimwear-Beachwear-Beach-Clothing/s0afg/?cid=10119&category=132",
          # "http://us.asos.com/Women-Swimwear-Beachwear-Bikinis/s0adk/?cid=10117&category=132",
          # "http://us.asos.com/Women-Swimwear-Beachwear-Fuller-Bust-Dd/s0aei/?cid=10120&category=132",
          # "http://us.asos.com/Women-Swimwear-Beachwear-Designer/s0ahc/?cid=10122&category=132",
          # "http://us.asos.com/Women-Swimwear-Beachwear-High-Waisted-Bikini/10m8j1/?cid=17551&category=132",
          # "http://us.asos.com/Women-Maternity-Maternity-Swimwear/tn903/?cid=11839&category=323",
          # "http://us.asos.com/Seperates-swimwear-Mix-and-match-swimwear/s0acm/?cid=10126&category=132",
          # "http://us.asos.com/Women-Swimwear-Beachwear-Swimsuits/s0abo/?cid=10118&category=132",
          # "http://us.asos.com/Women-Swimwear-Beachwear-Tankinis/s0age/?cid=11188&category=132",
          # "http://us.asos.com/Women-Sunglasses-Aviator-Sunglasses/xtcfd/?cid=15191&WT.ac=CP|WW|sunglasses|head|aviator&CTAref=Cat_Header&category=100",
          # "http://us.asos.com/Women/Sunglasses/Cat-Eye-Sunglasses/Cat/pgecategory.aspx?cid=17432&WT.ac=CP|WW|sunglasses|head|cateye&CTAref=Cat_Header&category=100",
          # "http://us.asos.com/Women-Sunglasses-Designer-Sunglasses/xtrqa/?cid=15194&WT.ac=CP|WW|sunglasses|head|designer&CTAref=Cat_Header&category=100",
          # "http://us.asos.com/Women-Sunglasses-Oversized-Sunglasses/11kvdp/?cid=17434&WT.ac=CP|WW|sunglasses|head|oversized&CTAref=Cat_Header&category=100",
          # "http://us.asos.com/Women/Sunglasses/Round-Sunglasses/Cat/pgecategory.aspx?cid=17433&WT.ac=CP|WW|sunglasses|head|round&CTAref=Cat_Header&category=100",
          # "http://us.asos.com/Women-Sunglasses-Wayfarer-Sunglasses/10ahvo/?cid=15192&WT.ac=CP|WW|sunglasses|head|wayfarer&CTAref=Cat_Header&category=100",
          # "http://us.asos.com/Women-Dresses-Body-Conscious-Dresses/wdz4i/?cid=13720&WT.ac=CP|WW|dresses|head|bodycon&CTAref=Cat_Header&category=144",
          # "http://us.asos.com/Women-Dresses-Dresses-For-Weddings/ythh3/?cid=13934&WT.ac=CP|WW|dresses|head|weddings&CTAref=Cat_Header&category=351",
          # "http://us.asos.com/Women-Dresses-Evening-Dresses/s04wr/?cid=8857&WT.ac=CP|WW|dresses|head|evening&CTAref=Cat_Header&category=352",
          # "http://us.asos.com/Women-Dresses-Floral-Dresses/vxnoc/?cid=12969&WT.ac=CP|WW|dresses|head|floral&CTAref=Cat_Header&category=351",
          # "http://us.asos.com/Women-Dresses-Lace-Dresses/vxnr6/?cid=12970&WT.ac=CP|WW|dresses|head|lace&CTAref=Cat_Header&category=351",
          # "http://us.asos.com/Women-Maternity-Dresses/s0bl2/?cid=8343&WT.ac=CP|WW|dresses|head|maternity&CTAref=Cat_Header&category=315",
          # "http://us.asos.com/Women-Dresses-Maxi-Dresses/smytg/?cid=9979&WT.ac=CP|WW|dresses|head|maxi&CTAref=Cat_Header&category=146",
          # "http://us.asos.com/Women-Dresses-Mini-Dresses/wdyut/?cid=13597&WT.ac=CP|WW|dresses|head|mini&CTAref=Cat_Header&category=148",
          # "http://us.asos.com/Women-Dresses-Party-Dresses/s052o/?cid=11057&WT.ac=CP|WW|dresses|head|party&CTAref=Cat_Header&category=351",
          # "http://us.asos.com/Women-Dresses-Summer-Dresses/vxlwy/?cid=10860&WT.ac=CP|WW|dresses|head|summer&CTAref=Cat_Header&category=351",
          # "http://us.asos.com/Women-Dresses-Workwear-Dresses/sqrrj/?cid=11464&WT.ac=CP|WW|dresses|head|workwear&CTAref=Cat_Header&category=351",
          # "http://us.asos.com/Women-Tops-Blouses/xtryu/?cid=15199&category=10",
          # "http://us.asos.com/Women-Tops-Bodies/sofaz/?cid=11323&category=350",
          # "http://us.asos.com/Women-Tops-Camis/xt18e/?cid=15202&category=123",
          # "http://us.asos.com/Women-Tops-Crop-Tops/xtr6n/?cid=15196&category=14",
          # "http://us.asos.com/Women-Tops-Evening-Tops/snlm5/?cid=11320&category=14",
          # "http://us.asos.com/Women-Tops-Hoodies-Sweatshirts/z6jq0/?cid=11321&category=8",
          # "http://us.asos.com/Women-Tops-Kimonos/xtqqb/?cid=15198&category=156",
          # "http://us.asos.com/Women-Tops-Printed-Tops/vuo6q/?cid=12800&category=14",
          # "http://us.asos.com/Women-Tops-Shirts/xts1x/?cid=15200&category=10",
          # "http://us.asos.com/Women-T-Shirts-Tanks/101vt4/?cid=4718&category=2",
          # "http://us.asos.com/Women-Pants-Leggings-Cropped-Pants/w3tbu/?cid=12911&category=30",
          # "http://us.asos.com/Women/Trousers-Leggings/Flares/Cat/pgecategory.aspx?cid=12917&category=113",
          # "http://us.asos.com/Women-Pants-Leggings-Sweat-Pants/xtjjy/?cid=15204&category=34",
          # "http://us.asos.com/Women-Leggings/10l937/?cid=16037&category=113",
          # "http://us.asos.com/Women-Pants-Leggings-Peg-Leg-Pants/xsq11/?cid=13686&category=113",
          # "http://us.asos.com/Women-Pants-Leggings-Printed-Pants/104e1a/?cid=17397&category=113",
          # "http://us.asos.com/Women-Pants-Leggings-Skinny-Pants/104e28/?cid=17398&category=32",
          # "http://us.asos.com/Women-Pants-Leggings-Straight-Leg-Pants/104eue/?cid=17399&category=113",
          # "http://us.asos.com/Women/Trousers-Leggings/Wide-Leg-Trousers/Cat/pgecategory.aspx?cid=17400&category=113",
          # "http://us.asos.com/Women-Pants-Leggings-Work-Pants/xtcan/?cid=15203&category=113",
          # "http://us.asos.com/Women-Pants-Leggings-Leather-Leggings-Pants/1160dp/?cid=17934&category=113"]

          list_cate.each do |link|
            FashionCrawler::Models::Resource.create({
              url: link.to_s + "&r=2" ,
              task: 'AsosusProcessAtCatePage',
              is_visited: false,
              site_name: 'Asosus',
              store: FashionCrawler::Models::Store.find_by(name: 'Asosus')
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


    class AsosusProcessAtCatePage
      def self.execute(url, body)
        doc = Nokogiri::HTML(body)
        begin
          category = url.scan(/category=(\d+)/).join("")

          doc.xpath("//a").each do |link|
            if link['href'].present? && link['href'].match(/pgeproduct.aspx\?iid=\d+&cid=\d+/) && category.to_i > 0
              detail_url = "#{link["href"]}&category=#{category}" + "&r=2"
               unless detail_url.match(/http/)
                 detail_url = "http://www.asos.com" + detail_url
               end
              unless FashionCrawler::Models::Resource.where(url: detail_url).exists?
                puts "!!!!!!!!!!!!#{detail_url}!!!!!!!!!!"

                FashionCrawler::Models::Resource.create({
                url: detail_url,
                task: 'AsosusProcessAtDetailPage',
                is_visited: false,
                site_name: 'Asosus',
                store: FashionCrawler::Models::Store.find_by(name: 'Asosus')
                })
              end
            # elsif link.text.match(/Next/)
            #   page_index = link["href"].to_s.scan(/pge=(\d+)/).join('')
            #   paging_url = url.gsub(/&pge=\d+/, "") + "&pge=#{page_index}"
            #   unless FashionCrawler::Models::Resource.where(url: paging_url).exists?
            #     puts "-----------------#{paging_url}--------------------"

            #     FashionCrawler::Models::Resource.create({
            #       url: paging_url,
            #       task: 'AsosusProcessAtCatePage',
            #       is_visited: false,
            #       site_name: 'Asosus',
            #       store: FashionCrawler::Models::Store.find_by(name: 'Asosus')
            #       })
            # end
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

    class AsosusProcessAtDetailPage
      def self.execute(url, body)
        doc = Nokogiri::HTML(body)
        begin

          url2 = url.gsub(/\&category=(.)*/, "")
          product = FashionCrawler::Models::Item.where(link: url2).first
          if product.nil?
            item = FashionCrawler::Models::Item.new
            item.link = url2
            name = doc.at_xpath("//span[@class='product_title']")
            item.name = name.text.strip unless name.nil?
            brand_name = ''
            doc.xpath("//h2").each do |h2|
              if h2.text.match(/ABOUT/)
                brand_name = h2.text.gsub(/ABOUT/, '').strip
                break
              end
            end

            unless brand_name.nil?
              master_brand = MasterBrand.by_brand_name(brand_name)
              unless master_brand.nil?
                item.brand_id = master_brand.brand_id
                item.brand_name = MasterBrand.id_is_other?(item.brand_id) ? brand_name : master_brand.brand_name
                item.brand_name_ja = master_brand.brand_name_ja
              end
            end

            item.site_id = 22
            item.site_name = "Asosus"
          else
            item = product
          end

          item.description = ""
          description = doc.xpath("//span[@class='infoline']").each do |info|
            item.description << '\n' << info.text.strip
          end

          file_name = url.scan(/(pgeproduct.aspx\?iid=\d+)/).join('')
          unless file_name.present?
            file_name = "index.html?" + url.scan(/(iid=\d+)/).join('')
          end

          directory_name = "asosus_tmp"
          dirname = File.basename(Dir.getwd)
          if dirname == directory_name
            Dir.chdir ".."
          end
          Dir.mkdir(directory_name) unless File.exists?(directory_name)
          Dir.chdir directory_name
          begin
            download_process = Thread.new { IO.popen "wget #{url}" }
            sleep(10) until !download_process.alive?
            html_content = File.open("#{file_name}", "r").read
            if html_content.scan(/class="previousprice".*>.*(\$.*)<\/span>/).present?
              original_base_price = html_content.scan(/class="product_price_details".*>(\$.*)<\/span>/).join('')
              original_price = html_content.scan(/class="previousprice".*>.*(\$.*)<\/span>/).join('')
            else
              original_price = html_content.scan(/class="product_price_details".*>.*(\$.*)<\/span>/).join('')
            end
            system("rm #{file_name}")
            Dir.chdir ".."
          rescue => e
          ensure
            download_process.exit
          end
          # original_price_node = doc.at_xpath("//div[@class='product_price']//span[@class='product_price_details']")
          # original_base_price_node = doc.at_xpath("//div[@class='product_price']//span[@class='previousprice']")

          if original_price.present?
            item.original_price = original_price
            item.price = CurrencyRate.convert_price_to_yen("USD", item.original_price, "$")
          end

          if original_base_price.present?
            item.original_base_price = original_base_price
            item.base_price = CurrencyRate.convert_price_to_yen("USD", item.original_base_price, "$")
          end

          images = []
          doc.xpath("//img").each do |img|
            if img["src"].present? && img["src"].match(/xl\.jpg/)
              images << img["src"]
            end
          end
          item.images = images.join(",")


          category = url.scan(/&category=(\d+)/).join('')
          item.category_id = category
          master_category = MasterCategory.by_category_3_id(category.to_i)
          unless master_category.nil?
            item.category_name = master_category.category_3
            general_category_id = master_category.general_category_id
          end

          number_of_products = 0
          doc.inner_html.scan(/arrSzeCol_ctl00_ContentMainPage_ctlSeparateProduct\[\d+\] = new Array\(\d+,".*","\w+","(\w+)",.*\);/).each do |status|
            number_of_products = number_of_products + 1  if status.first == "True"
          end

          if number_of_products > 0
             item.flag = 1
             item.number_of_products = number_of_products
          else
             item.flag = 0
          end

          sizes = []
          doc.inner_html.scan(/arrSzeCol_ctl00_ContentMainPage_ctlSeparateProduct\[\d+\] = new Array\(\d+,"(.*)","\w+","\w+",.*\);/).each do |size|
            sizes << size.first unless sizes.include?(size.first)
          end

          unless sizes.empty?
            item.original_size = sizes.join(",")
            if general_category_id.nil?
              item.size = item.original_size
            else
              item.size = MasterSize.convert_sizes(item.original_size, "US", general_category_id)
            end
          end

          if item.size == "One Size" || item.size == "No Size"
            number_of_products = 3
          end

          if number_of_products > 0
             item.flag = 1
             item.number_of_products = number_of_products
          else
             item.flag = 0
          end

          if item.name.present? && item.brand_name.present? && item.price.present? && item.flag == 1 && category.to_i > 0
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
