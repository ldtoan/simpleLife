# encoding: utf-8
require 'nokogiri'
require 'unicode'
require 'uri'
require 'date'
require 'open-uri'

module FashionCrawler
  module Tasks
    class SaksfifthavenueProcessAtMainPage
      def self.execute(url, body)
        begin
          list_cate = ["http://www.saksfifthavenue.com/Shoes-and-Handbags/Shoes/Boots/Ankle/shop/_/N-52g1dp/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306438397?category=78",
               "http://www.saksfifthavenue.com/Shoes-and-Handbags/Shoes/Boots/Over-The-Knee/shop/_/N-52g3a2/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306440858?category=78",
               "http://www.saksfifthavenue.com/Shoes-and-Handbags/Shoes/Boots/Tall/shop/_/N-52g1dr/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306438399?category=78",
               "http://www.saksfifthavenue.com/Shoes-and-Handbags/Shoes/Boots/Cold-Weather/shop/_/N-52g4dp/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306442285?category=78",
               "http://www.saksfifthavenue.com/Shoes-and-Handbags/Shoes/Boots/Rainwear/shop/_/N-52g1ds/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306438400?category=78",
               "http://www.saksfifthavenue.com/Shoes-and-Handbags/Shoes/Ballet-Flats/shop/_/N-52g1du/Ne-6lvnb5?category=78",
               "http://www.saksfifthavenue.com/Shoes-and-Handbags/Shoes/Evening/shop/_/N-52flpe/Ne-6lvnb5?category=78",
               "http://www.saksfifthavenue.com/Shoes-and-Handbags/Shoes/Exotics/shop/_/N-52jder/Ne-6lvnb5?category=78",
               "http://www.saksfifthavenue.com/Shoes-and-Handbags/Shoes/Lace-Ups-Loafers-and-Moccasins/Loafers-and-Moccasins/shop/_/N-52g1dw/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306438404?category=78",
               "http://www.saksfifthavenue.com/Shoes-and-Handbags/Shoes/Lace-Ups-Loafers-and-Moccasins/Lace-Ups-and-Oxfords/shop/_/N-52g1dv/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306438403?category=78",
               "http://www.saksfifthavenue.com/Shoes-and-Handbags/Shoes/Pumps-and-Slingbacks/Pumps/shop/_/N-52g1e1/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306438409?category=78",
               "http://www.saksfifthavenue.com/Shoes-and-Handbags/Shoes/Pumps-and-Slingbacks/Platforms/shop/_/N-52g1e4/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306438412?category=78",
               "http://www.saksfifthavenue.com/Shoes-and-Handbags/Shoes/Pumps-and-Slingbacks/Peep-Toe/shop/_/N-52j8io/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306587616?category=78",
               "http://www.saksfifthavenue.com/Shoes-and-Handbags/Shoes/Pumps-and-Slingbacks/Slingbacks/shop/_/N-52g1e2/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306438410?category=78",
               "http://www.saksfifthavenue.com/Shoes-and-Handbags/Shoes/Pumps-and-Slingbacks/Point-Toe/shop/_/N-52jrcj/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306612019?category=78",
               "http://www.saksfifthavenue.com/Shoes-and-Handbags/Shoes/Sandals/Flats/shop/_/N-52g5ms/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306443908?category=78",
               "http://www.saksfifthavenue.com/Shoes-and-Handbags/Shoes/Sandals/Heels/shop/_/N-52g5mt/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306443909?category=78",
               "http://www.saksfifthavenue.com/Shoes-and-Handbags/Shoes/Sandals/Wedges/shop/_/N-52g5mu/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306443910?category=78",
               "http://www.saksfifthavenue.com/Shoes-and-Handbags/Shoes/Slippers/shop/_/N-52g0h5/Ne-6lvnb5?category=78",
               "http://www.saksfifthavenue.com/Shoes-and-Handbags/Shoes/Sneakers/shop/_/N-52iok0/Ne-6lvnb5?category=78",
               "http://www.saksfifthavenue.com/Shoes-and-Handbags/Shoes/Wedding/shop/_/N-52jy8o/Ne-6lvnb5?category=78",
               "http://www.saksfifthavenue.com/Shoes-and-Handbags/Shoes/Wedges-and-Espadrilles/shop/_/N-52ibor/Ne-6lvnb5?category=66",
               "http://www.saksfifthavenue.com/Shoes-and-Handbags/Handbags/Bucket-Bags/shop/_/N-52jy6k/Ne-6lvnb5?category=78",
               "http://www.saksfifthavenue.com/Shoes-and-Handbags/Beach-Bags/shop/_/N-52idq0/Ne-6lvnb5?category=78",
               "http://www.saksfifthavenue.com/Shoes-and-Handbags/Handbags/Backpacks/shop/_/N-52jo9w/Ne-6lvnb5?category=84",
               "http://www.saksfifthavenue.com/Shoes-and-Handbags/Handbags/Clutches/Day/shop/_/N-52jste/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306613922?category=78",
               "http://www.saksfifthavenue.com/Shoes-and-Handbags/Handbags/Clutches/Evening/shop/_/N-52jstf/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306613923?category=78",
               "http://www.saksfifthavenue.com/Shoes-and-Handbags/Handbags/Clutches/Pouches/shop/_/N-52jwgk/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306618644?category=78",
               "http://www.saksfifthavenue.com/Shoes-and-Handbags/Exotics/shop/_/N-52jdfb/Ne-6lvnb5?category=78",
               "http://www.saksfifthavenue.com/Shoes-and-Handbags/Crossbody-Bags/shop/_/N-52ilwg/Ne-6lvnb5?category=78",
               "http://www.saksfifthavenue.com/Shoes-and-Handbags/Hobos/shop/_/N-52g27b/Ne-6lvnb5?category=78",
               "http://www.saksfifthavenue.com/Shoes-and-Handbags/Handbags/Mini-Bags/shop/_/N-52g5nh/Ne-6lvnb5?category=78",
               "http://www.saksfifthavenue.com/Shoes-and-Handbags/Shoulder-Bags/shop/_/N-52flqm/Ne-6lvnb5?category=82",
               "http://www.saksfifthavenue.com/Shoes-and-Handbags/Totes/shop/_/N-52g279/Ne-6lvnb5?category=78",
               "http://www.saksfifthavenue.com/Shoes-and-Handbags/Top-Handles-and-Satchels/shop/_/N-52flqp/Ne-6lvnb5?category=78",
               "http://www.saksfifthavenue.com/Shoes-and-Handbags/Wallets-and-Cases/Card-Cases-and-Coin-Purses/shop/_/N-52g52z/Ne-6lvnb5?category=88",
               "http://www.saksfifthavenue.com/Shoes-and-Handbags/Wallets-and-Cases/Cosmetic-Bags/shop/_/N-52g530/Ne-6lvnb5?category=78",
               "http://www.saksfifthavenue.com/Shoes-and-Handbags/Wallets-and-Cases/Mobile-and-Tech-Cases/shop/_/N-52ik9k/Ne-6lvnb5?category=78",
               "http://www.saksfifthavenue.com/Shoes-and-Handbags/Wallets-and-Cases/Wallets/shop/_/N-52g52y/Ne-6lvnb5?category=78",
               "http://www.saksfifthavenue.com/Beauty-and-Fragrance/For-Her/Gifts-and-Gift-Sets/shop/_/N-52flry/Ne-6lvnb5?category=141",
               "http://www.saksfifthavenue.com/Beauty-and-Fragrance/For-Her/Fragrance/shop/_/N-52ikt1/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306556885?category=117",
               "http://www.saksfifthavenue.com/Beauty-and-Fragrance/For-Her/Fragrance/Bath-and-Body/shop/_/N-52juls/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306616240?category=117",
               "http://www.saksfifthavenue.com/Beauty-and-Fragrance/For-Her/Fragrance/Solid-Perfume-and-Purse-Spray/shop/_/N-52fqoc/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306424524?category=117",
               "http://www.saksfifthavenue.com/Beauty-and-Fragrance/For-Her/Fragrance/Gifts-and-Gift-Sets/shop/_/N-52g0jw/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306437324?category=141",
               "http://www.saksfifthavenue.com/The-Men-s-Store/Apparel/Swimwear/shop/_/N-52fqqp/Ne-6lvnb5?category=260",
               "http://www.saksfifthavenue.com/Just-Kids/Baby-(0-24-Months)/Baby-Bags/shop/_/N-52fltj/Ne-6lvnb5?category=330",
               "http://www.saksfifthavenue.com/Beauty-and-Fragrance/For-Her/Bath-and-Body/Body-Lotion/shop/_/N-52g1y9/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306439137?category=117",
               "http://www.saksfifthavenue.com/Beauty-and-Fragrance/For-Her/Bath-and-Body/Cleansers/shop/_/N-52g1xa/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306439102?category=117",
               "http://www.saksfifthavenue.com/Beauty-and-Fragrance/For-Her/Bath-and-Body/Exfoliants-Salts-and-Scrubs/shop/_/N-52jujk/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306616160?category=117",
               "http://www.saksfifthavenue.com/Beauty-and-Fragrance/For-Her/Bath-and-Body/Body-Treatments/shop/_/N-52jwhh/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306618677?category=117",
               "http://www.saksfifthavenue.com/Beauty-and-Fragrance/For-Him/Cologne-and-After-Shave/shop/_/N-52fls5/Ne-6lvnb5?category=262",
               "http://www.saksfifthavenue.com/Beauty-and-Fragrance/For-Him/Gifts-and-Gift-Sets/shop/_/N-52g367/Ne-6lvnb5?category=141",
               "http://www.saksfifthavenue.com/Jewelry-and-Accessories/Jewelry/Earrings-and-Charms/Dangle-and-Drop/shop/_/N-52fqfy/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306424222?category=91",
               "http://www.saksfifthavenue.com/Jewelry-and-Accessories/Jewelry/Earrings-and-Charms/Studs/shop/_/N-52fms6/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306419478?category=91",
               "http://www.saksfifthavenue.com/Jewelry-and-Accessories/Jewelry/Earrings-and-Charms/Hoops/shop/_/N-52fms5/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306419477?category=91",
               "http://www.saksfifthavenue.com/Jewelry-and-Accessories/Jewelry/Earrings-and-Charms/Clips/shop/_/N-52fms4/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306419476?category=91",
               "http://www.saksfifthavenue.com/Jewelry-and-Accessories/Jewelry/Earrings-and-Charms/Earring-Charms/shop/_/N-52g1ye/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306439142?category=91",
               "http://www.saksfifthavenue.com/Jewelry-and-Accessories/Jewelry/Earrings-and-Charms/Single-Earring/shop/_/N-52jy70/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306620892?category=91",
               "http://www.saksfifthavenue.com/Jewelry-and-Accessories/Jewelry/Earrings-and-Charms/Fine-Jewelry/shop/_/N-52jum1/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306616249?category=91",
               "http://www.saksfifthavenue.com/Jewelry-and-Accessories/Jewelry/Necklaces-and-Enhancers/Statement-Necklaces/shop/_/N-52g5ez/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306443627?category=227",
               "http://www.saksfifthavenue.com/Jewelry-and-Accessories/Jewelry/Necklaces-and-Enhancers/Chains-and-Strands/shop/_/N-52fmsd/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306419485?category=90",
               "http://www.saksfifthavenue.com/Jewelry-and-Accessories/Jewelry/Necklaces-and-Enhancers/Pendants/shop/_/N-52fmsc/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306419484?category=90",
               "http://www.saksfifthavenue.com/Jewelry-and-Accessories/Jewelry/Necklaces-and-Enhancers/Enhancers-and-Charms/shop/_/N-52fta9/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306427905?category=90",
               "http://www.saksfifthavenue.com/Jewelry-and-Accessories/Jewelry/Necklaces-and-Enhancers/Collars-and-Chokers/shop/_/N-52jy74/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306620896?category=90",
               "http://www.saksfifthavenue.com/Jewelry-and-Accessories/Jewelry/Necklaces-and-Enhancers/Fine-Jewelry/shop/_/N-52jum2/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306616250?category=90",
               "http://www.saksfifthavenue.com/Jewelry-and-Accessories/Jewelry/Brooches/shop/_/N-52flr6/Ne-6lvnb5?category=119",
               "http://www.saksfifthavenue.com/Jewelry-and-Accessories/Jewelry/Rings/Statement/shop/_/N-52jum4/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306616252?category=229",
               "http://www.saksfifthavenue.com/Jewelry-and-Accessories/Jewelry/Rings/Stackable-Rings/shop/_/N-52jum5/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306616253?category=92",
               "http://www.saksfifthavenue.com/Jewelry-and-Accessories/Jewelry/Rings/Gold/shop/_/N-52jum6/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306616254?category=92",
               "http://www.saksfifthavenue.com/Jewelry-and-Accessories/Jewelry/Rings/Silver/shop/_/N-52jum7/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306616255?category=92",
               "http://www.saksfifthavenue.com/Jewelry-and-Accessories/Jewelry/Rings/Pearl/shop/_/N-52jum8/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306616256?category=92",
               "http://www.saksfifthavenue.com/Jewelry-and-Accessories/Jewelry/Rings/Fine-Jewelry/shop/_/N-52jum9/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306616257?category=92",
               "http://www.saksfifthavenue.com/Jewelry-and-Accessories/Jewelry/Bracelets-and-Charms/Bangles-and-Cuffs/shop/_/N-52fmsk/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306419492?category=93",
               "http://www.saksfifthavenue.com/Jewelry-and-Accessories/Jewelry/Bracelets-and-Charms/Wrap-and-Beaded/shop/_/N-52fqg4/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306424228?category=93",
               "http://www.saksfifthavenue.com/Jewelry-and-Accessories/Jewelry/Bracelets-and-Charms/Chains-and-Strands/shop/_/N-52fqg1/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306424225?category=93",
               "http://www.saksfifthavenue.com/Jewelry-and-Accessories/Jewelry/Bracelets-and-Charms/Charms/shop/_/N-52fmsl/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306419493?category=93",
               "http://www.saksfifthavenue.com/Jewelry-and-Accessories/Jewelry/Bracelets-and-Charms/Fine-Jewelry/shop/_/N-52jum3/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306616251?category=93",
               "http://www.saksfifthavenue.com/Jewelry-and-Accessories/Watches/For-Him/Fashion/shop/_/N-52fqtj/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306424711?category=98",
               "http://www.saksfifthavenue.com/Jewelry-and-Accessories/Watches/For-Him/Fine/shop/_/N-52fqti/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306424710?category=98",
               "http://www.saksfifthavenue.com/Jewelry-and-Accessories/Watches/For-Her/Fashion/shop/_/N-52fsyd/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306427477?category=98",
               "http://www.saksfifthavenue.com/Jewelry-and-Accessories/Watches/For-Her/Fine/shop/_/N-52fteo/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306428064?category=98",
               "http://www.saksfifthavenue.com/Jewelry-and-Accessories/Watches/For-Her/Watch-Bands/shop/_/N-52fqtp/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306424717?category=98",
               "http://www.saksfifthavenue.com/Jewelry-and-Accessories/Accessories/Scarves/Prints/shop/_/N-52je3s/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306594856?category=105",
               "http://www.saksfifthavenue.com/Jewelry-and-Accessories/Accessories/Scarves/Silks/shop/_/N-52je3u/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306594858?category=105",
               "http://www.saksfifthavenue.com/Jewelry-and-Accessories/Accessories/Scarves/Evening/shop/_/N-52je3x/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306594861?category=105",
               "http://www.saksfifthavenue.com/Jewelry-and-Accessories/Accessories/Scarves/Cold-Weather/shop/_/N-52jumg/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306616264?category=105",
               "http://www.saksfifthavenue.com/Jewelry-and-Accessories/Accessories/Scarves/Circle-Scarves/shop/_/N-52jumf/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306616263?category=105",
               "http://www.saksfifthavenue.com/Jewelry-and-Accessories/Sunglasses/shop/_/N-52flre/Ne-6lvnb5?category=100",
               "http://www.saksfifthavenue.com/Jewelry-and-Accessories/Accessories/Boleros-Jackets-and-Vests/shop/_/N-52jumi/Ne-6lvnb5?category=149",
               "http://www.saksfifthavenue.com/Jewelry-and-Accessories/Accessories/Hats-and-Gloves/Gloves-and-Mittens/shop/_/N-52id1l/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306546825?category=108",
               "http://www.saksfifthavenue.com/Jewelry-and-Accessories/Accessories/Hats-and-Gloves/Hats-and-Earmuffs/shop/_/N-52id1k/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306546824?category=106",
               "http://www.saksfifthavenue.com/Jewelry-and-Accessories/Accessories/Belts/Medium/shop/_/N-52j8iy/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306587626?category=109",
               "http://www.saksfifthavenue.com/Jewelry-and-Accessories/Accessories/Belts/Wide/shop/_/N-52j8j0/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306587628?category=109",
               "http://www.saksfifthavenue.com/Jewelry-and-Accessories/Accessories/Belts/Skinny/shop/_/N-52j8iz/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306587627?category=109",
               "http://www.saksfifthavenue.com/Jewelry-and-Accessories/Accessories/Umbrellas-Key-Chains-and-Totes/Umbrellas-and-Key-Chains/shop/_/N-52jwi1/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306618697?category=112",
               "http://www.saksfifthavenue.com/Jewelry-and-Accessories/Accessories/Umbrellas-Key-Chains-and-Totes/Totes-and-Luggage/shop/_/N-52fw5v/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306431635?category=112",
               "http://www.saksfifthavenue.com/Jewelry-and-Accessories/Accessories/Hair-and-Cosmetic-Accessories/Hair-Accessories/shop/_/N-52g0hd/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306437233?category=120",
               "http://www.saksfifthavenue.com/Jewelry-and-Accessories/Accessories/Hair-and-Cosmetic-Accessories/Cosmetic-Bags/shop/_/N-52g0hb/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306437231?category=118",
               "http://www.saksfifthavenue.com/Jewelry-and-Accessories/Accessories/Wallets-and-Cases/Wallets/shop/_/N-52ifks/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306550108?category=86",
               "http://www.saksfifthavenue.com/Jewelry-and-Accessories/Accessories/Wallets-and-Cases/Card-Cases-and-Coin-Purses/shop/_/N-52ifkq/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306550106?category=88",
               "http://www.saksfifthavenue.com/Jewelry-and-Accessories/Accessories/Wallets-and-Cases/Mobile-and-Tech-Cases/shop/_/N-52jkwr/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306603675?category=86",
               "http://www.saksfifthavenue.com/Jewelry-and-Accessories/Accessories/Wallets-and-Cases/Cosmetic-Bags/shop/_/N-52jkvn/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306603635?category=86",
               "http://www.saksfifthavenue.com/Jewelry-and-Accessories/Accessories/Tights-and-Hosiery/shop/_/N-52iqh2/Ne-6lvnb5?category=114",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Dresses/Cocktail/shop/_/N-52foua/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306422146?category=143",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Dresses/Evening-Gown/shop/_/N-52fou4/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306422140?category=127",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Dresses/Day/shop/_/N-52fouh/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306422153?category=144",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Dresses/Workwear/shop/_/N-52fzy2/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306436538?category=145",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Dresses/Maxi/shop/_/N-52g2z4/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306440464?category=146",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Dresses/Mini/shop/_/N-52g2z5/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306440465?category=148",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Dresses/Prints/shop/_/N-52ftn7/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306428371?category=153",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Dresses/Fit-and-Flare/shop/_/N-52jsty/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306613942?category=153",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Dresses/Bridesmaid/shop/_/N-52ft5i/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306427734?category=135",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Dresses/Mother-of-the-Bride/shop/_/N-52jqku/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306611022?category=157",
               "http://www.saksfifthavenue.com/Jewelry-and-Accessories/Tech-Accessories/shop/_/N-52j6sz/Ne-6lvnb5?category=111",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Tops/Blouses/shop/_/N-52fzzj/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306436591?category=10",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Tops/T-Shirts/shop/_/N-52fota/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306422110?category=2",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Tops/Knits/shop/_/N-52fzzy/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306436606?category=6",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Tops/Tunics/shop/_/N-52jdr1/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306594397?category=5",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Tops/Collared-and-Button-Downs/shop/_/N-52jdr0/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306594396?category=14",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Tops/Party-Tops/shop/_/N-52fotb/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306422111?category=14",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Tops/Sweatshirts/shop/_/N-52jsvi/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306613998?category=10",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Tops/Long-Sleeve/shop/_/N-52jsvj/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306613999?category=3",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Tops/Short-Sleeve/shop/_/N-52jsvk/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306614000?category=14",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Tops/Sleeveless/shop/_/N-52g27z/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306439487?category=1",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Sweaters/Cashmere/shop/_/N-52ilju/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306557850?category=6",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Sweaters/Cardigans/shop/_/N-52iljt/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306557849?category=7",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Sweaters/Scoop-Crew-and-Boatnecks/shop/_/N-52iljw/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306557852?category=6",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Sweaters/Cowl-and-Turtlenecks/shop/_/N-52iljv/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306557851?category=6",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Sweaters/Sweater-Coats/shop/_/N-52iljx/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306557853?category=6",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Sweaters/V-Necks/shop/_/N-52iljy/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306557854?category=6",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Sweaters/Statement-Knits/shop/_/N-52jsvm/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306614002?category=6",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Swimwear/Coverups/shop/_/N-52fow8/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306422216?category=132",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Swimwear/One-Piece/shop/_/N-52fow6/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306422214?category=36",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Swimwear/Two-Piece/shop/_/N-52fow7/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306422215?category=132",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Jackets-and-Vests/Jackets/shop/_/N-52j3av/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306580855?category=47",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Jackets-and-Vests/Blazers/shop/_/N-52jsvo/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306614004?category=52",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Jackets-and-Vests/Vests/shop/_/N-52j3aw/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306580856?category=47",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Jackets-and-Vests/Leather/shop/_/N-52jsvq/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306614006?category=47",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Pants-and-Shorts/Pants/shop/_/N-52g26j/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306439435?category=17",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Pants-and-Shorts/Skinny-Leg/shop/_/N-52fow1/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306422209?category=17",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Pants-and-Shorts/Jumpsuits/shop/_/N-52g1d2/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306438374?category=17",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Pants-and-Shorts/Cropped/shop/_/N-52fow4/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306422212?category=17",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Pants-and-Shorts/Shorts/shop/_/N-52fzwp/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306436489?category=17",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Pants-and-Shorts/Leggings-and-Loungewear/shop/_/N-52g26c/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306439428?category=113",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Pants-and-Shorts/Leather/shop/_/N-52jh2g/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306598696?category=17",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Denim/Skinny/shop/_/N-52ivp4/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306571000?category=26",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Denim/Boyfriend/shop/_/N-52jsub/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306613955?category=339",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Denim/Bootcut/shop/_/N-52ivp0/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306570996?category=20",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Denim/Flare/shop/_/N-52j1mv/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306578695?category=25",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Denim/Cropped-and-Shorts/shop/_/N-52jbnz/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306591695?category=22",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Denim/Color-and-Prints/shop/_/N-52j1jk/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306578576?category=35",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Denim/Distressed/shop/_/N-52jnz0/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306607644?category=24",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Denim/Maternity/shop/_/N-52j8k9/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306587673?category=314",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Outerwear/Puffers-and-Quilted/shop/_/N-52fovu/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306422202?category=57",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Outerwear/Wool-and-Cashmere/shop/_/N-52fovo/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306422196?category=44",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Outerwear/Leather-and-Fur/shop/_/N-52g00w/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306436640?category=42",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Outerwear/Coats/shop/_/N-52jsu6/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306613950?category=57",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Outerwear/Trenchcoats-and-Parkas/shop/_/N-52fovl/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306422193?category=43",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Skirts/Pencil/shop/_/N-52fzyz/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306436571?category=15",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Skirts/Fit-and-Flare/shop/_/N-52jsu0/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306613944?category=15",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Skirts/Mini/shop/_/N-52fovv/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306422203?category=15",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Skirts/Midi/shop/_/N-52jwhg/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306618676?category=15",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Skirts/Maxi/shop/_/N-52iqdk/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306564104?category=15",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Leggings/shop/_/N-52ib4o/Ne-6lvnb5?category=113",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Leather/Dresses/shop/_/N-52jsu2/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306613946?category=153",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Leather/Tops/shop/_/N-52jsu3/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306613947?category=14",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Leather/Jackets/shop/_/N-52jsu4/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306613948?category=47",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Leather/Bottoms/shop/_/N-52jsu5/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306613949?category=35",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Suits/shop/_/N-52ft07/Ne-6lvnb5?category=154",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Sleepwear-and-Loungewear/Robes-Wraps-and-Caftans/shop/_/N-52fmtn/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306419531?category=128",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Sizes-14-24/Sweaters/shop/_/N-52g47q/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306442070?category=6",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Sizes-14-24/Jackets-and-Vests/shop/_/N-52g3a5/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306440861?category=47",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Sizes-14-24/Outerwear/shop/_/N-52fq90/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306423972?category=57",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Sizes-14-24/Pants-and-Jumpsuits/shop/_/N-52fq8q/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306423962?category=17",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Sizes-14-24/Denim/shop/_/N-52fq8o/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306423960?category=35",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Sizes-14-24/Skirts/shop/_/N-52fq8u/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306423966?category=15",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Sizes-14-24/Swimwear/shop/_/N-52g0i2/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306437258?category=132",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Sizes-14-24/Lingerie-and-Sleepwear/shop/_/N-52fqx5/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306424841?category=126",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Maternity/shop/_/N-52fom3/Ne-6lvnb5?category=314",
               "http://www.saksfifthavenue.com/The-Men-s-Store/Apparel/Activewear/Tops/shop/_/N-52fnzz/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306421055?category=264",
               "http://www.saksfifthavenue.com/The-Men-s-Store/Apparel/Activewear/Bottoms/shop/_/N-52fo00/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306421056?category=267",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Lingerie/Bras/shop/_/N-52fmt3/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306419511?category=124",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Lingerie/Shapewear-and-Solutions/shop/_/N-52ftnn/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306428387?category=129",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Lingerie/Tights-and-Hosiery/shop/_/N-52fmt8/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306419516?category=114",
               "http://www.saksfifthavenue.com/Women-s-Apparel/Lingerie/Camisoles-and-Chemises/shop/_/N-52fmt5/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306419513?category=123",
               "http://www.saksfifthavenue.com/The-Men-s-Store/Apparel/Denim/Straight/shop/_/N-52ivjh/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306570797?category=180",
               "http://www.saksfifthavenue.com/The-Men-s-Store/Apparel/Denim/Slim/shop/_/N-52ivjg/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306570796?category=178",
               "http://www.saksfifthavenue.com/The-Men-s-Store/Apparel/Denim/Skinny/shop/_/N-52jssl/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306613893?category=182",
               "http://www.saksfifthavenue.com/The-Men-s-Store/Apparel/Denim/Bootcut-and-Relaxed/shop/_/N-52ivjf/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306570795?category=179",
               "http://www.saksfifthavenue.com/The-Men-s-Store/Apparel/Outerwear/Wool-and-Cashmere/shop/_/N-52ik7x/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306556125?category=204",
               "http://www.saksfifthavenue.com/The-Men-s-Store/Apparel/Outerwear/Leather-and-Shearling/shop/_/N-52ik7y/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306556126?category=198",
               "http://www.saksfifthavenue.com/The-Men-s-Store/Apparel/Outerwear/Down-and-Down-Alternative/shop/_/N-52ik7w/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306556124?category=211",
               "http://www.saksfifthavenue.com/The-Men-s-Store/Apparel/Outerwear/Lightweight-and-Rain/shop/_/N-52ik7z/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306556127?category=211",
               "http://www.saksfifthavenue.com/The-Men-s-Store/Apparel/Pants-and-Shorts/Dress-Pants/shop/_/N-52fo0o/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306421080?category=178",
               "http://www.saksfifthavenue.com/The-Men-s-Store/Apparel/Pants-and-Shorts/Casual-Pants/shop/_/N-52fo0p/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306421081?category=190",
               "http://www.saksfifthavenue.com/The-Men-s-Store/Apparel/Pants-and-Shorts/Shorts/shop/_/N-52flsn/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306418199?category=178",
               "http://www.saksfifthavenue.com/The-Men-s-Store/Apparel/Polos-and-Tees/Polos/shop/_/N-52fo11/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306421093?category=168",
               "http://www.saksfifthavenue.com/The-Men-s-Store/Apparel/Polos-and-Tees/Tees/shop/_/N-52fo12/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306421094?category=168",
               "http://www.saksfifthavenue.com/The-Men-s-Store/Apparel/Sportcoats-Suits-and-Vests/Sportcoats-and-Vests/shop/_/N-52g5h7/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306443707?category=263",
               "http://www.saksfifthavenue.com/The-Men-s-Store/Apparel/Sportcoats-Suits-and-Vests/Suits/shop/_/N-52g5h8/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306443708?category=263",
               "http://www.saksfifthavenue.com/The-Men-s-Store/Apparel/Sweaters-and-Sweatshirts/Sweaters/shop/_/N-52jrbx/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306611997?category=173",
               "http://www.saksfifthavenue.com/The-Men-s-Store/Apparel/Sweaters-and-Sweatshirts/Sweatshirts/shop/_/N-52jrby/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306611998?category=173",
               "http://www.saksfifthavenue.com/The-Men-s-Store/Apparel/Ties-and-Formalwear/Ties/shop/_/N-52fo1m/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306421114?category=249",
               "http://www.saksfifthavenue.com/The-Men-s-Store/Apparel/Ties-and-Formalwear/Bow-Ties-and-Formalwear/shop/_/N-52g5f4/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306443632?category=249",
               "http://www.saksfifthavenue.com/The-Men-s-Store/Apparel/Ties-and-Formalwear/Pocket-Squares/shop/_/N-52flsz/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306418211?category=249",
               "http://www.saksfifthavenue.com/The-Men-s-Store/Shoes/Boots/shop/_/N-52fnyc/Ne-6lvnb5?category=215",
               "http://www.saksfifthavenue.com/The-Men-s-Store/Apparel/Underwear-Socks-and-Sleepwear/Socks/shop/_/N-52fo0t/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306421085?category=246",
               "http://www.saksfifthavenue.com/The-Men-s-Store/Apparel/Underwear-Socks-and-Sleepwear/Underwear/shop/_/N-52fo0u/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306421086?category=246",
               "http://www.saksfifthavenue.com/The-Men-s-Store/Apparel/Underwear-Socks-and-Sleepwear/Loungewear-Pajamas-and-Robes/shop/_/N-52fo17/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306421099?category=257",
               "http://www.saksfifthavenue.com/The-Men-s-Store/Apparel/Underwear-Socks-and-Sleepwear/Undershirts/shop/_/N-52fo0v/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306421087?category=170",
               "http://www.saksfifthavenue.com/The-Men-s-Store/Shoes/Flip-Flops-and-Sandals/shop/_/N-52fny7/Ne-6lvnb5?category=212",
               "http://www.saksfifthavenue.com/The-Men-s-Store/Shoes/Drivers-and-Moccasins/shop/_/N-52fny8/Ne-6lvnb5?category=218",
               "http://www.saksfifthavenue.com/The-Men-s-Store/Shoes/Loafers/shop/_/N-52fqhr/Ne-6lvnb5?category=216",
               "http://www.saksfifthavenue.com/The-Men-s-Store/Shoes/Sneakers/shop/_/N-52fnyb/Ne-6lvnb5?category=213",
               "http://www.saksfifthavenue.com/The-Men-s-Store/Shoes/Lace-Ups/shop/_/N-52fny9/Ne-6lvnb5?category=218",
               "http://www.saksfifthavenue.com/The-Men-s-Store/Accessories/Bags-Briefcases-and-Totes/Messenger-Bags/shop/_/N-52fo2e/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306421142?category=220",
               "http://www.saksfifthavenue.com/The-Men-s-Store/Accessories/Bags-Briefcases-and-Totes/Briefcases/shop/_/N-52fo2g/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306421144?category=226",
               "http://www.saksfifthavenue.com/The-Men-s-Store/Accessories/Bags-Briefcases-and-Totes/Backpacks-and-Duffels/shop/_/N-52j37j/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306580735?category=223",
               "http://www.saksfifthavenue.com/The-Men-s-Store/Accessories/Bags-Briefcases-and-Totes/Totes/shop/_/N-52fo2f/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306421143?category=221",
               "http://www.saksfifthavenue.com/The-Men-s-Store/Accessories/Belts/shop/_/N-52flsw/Ne-6lvnb5?category=247",
               "http://www.saksfifthavenue.com/The-Men-s-Store/Accessories/Luggage-Travel-and-Umbrellas/Luggage/shop/_/N-52fo2j/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306421147?category=232",
               "http://www.saksfifthavenue.com/The-Men-s-Store/Accessories/Luggage-Travel-and-Umbrellas/Travel-Accessories/shop/_/N-52fo2i/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306421146?category=232",
               "http://www.saksfifthavenue.com/The-Men-s-Store/Accessories/Luggage-Travel-and-Umbrellas/Toiletry-Kits-and-Cases/shop/_/N-52flt2/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306418214?category=232",
               "http://www.saksfifthavenue.com/The-Men-s-Store/Accessories/Luggage-Travel-and-Umbrellas/Umbrellas/shop/_/N-52flt1/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306418213?category=232",
               "http://www.saksfifthavenue.com/The-Men-s-Store/Accessories/Hats-Scarves-and-Gloves/Hats/shop/_/N-52iiw4/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306554404?category=244",
               "http://www.saksfifthavenue.com/The-Men-s-Store/Accessories/Hats-Scarves-and-Gloves/Scarves-and-Gloves/shop/_/N-52iiw6/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306554406?category=244",
               "http://www.saksfifthavenue.com/The-Men-s-Store/Accessories/Mobile-and-Tech-Cases/shop/_/N-52j6ym/Ne-6lvnb5?category=251",
               "http://www.saksfifthavenue.com/The-Men-s-Store/Accessories/Sunglasses-and-Opticals/Sunglasses/shop/_/N-52jrc0/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306612000?category=237",
               "http://www.saksfifthavenue.com/The-Men-s-Store/Accessories/Sunglasses-and-Opticals/Opticals/shop/_/N-52jrc1/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306612001?category=237",
               "http://www.saksfifthavenue.com/The-Men-s-Store/Cuff-Links-Watches-and-Jewelry/Cuff-Links-and-Tie-Bars/shop/_/N-52fnyj/Ne-6lvnb5?category=250",
               "http://www.saksfifthavenue.com/The-Men-s-Store/Cuff-Links-Watches-and-Jewelry/Jewelry/Necklaces-and-Pendants/shop/_/N-52fo1i/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306421110?category=250",
               "http://www.saksfifthavenue.com/The-Men-s-Store/Cuff-Links-Watches-and-Jewelry/Jewelry/Bracelets/shop/_/N-52fo1h/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306421109?category=250",
               "http://www.saksfifthavenue.com/The-Men-s-Store/Cuff-Links-Watches-and-Jewelry/Jewelry/Rings/shop/_/N-52fo1j/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306421111?category=250",
               "http://www.saksfifthavenue.com/The-Men-s-Store/Cuff-Links-Watches-and-Jewelry/Lapel-Pins/shop/_/N-52jrwk/Ne-6lvnb5?category=250",
               "http://www.saksfifthavenue.com/The-Men-s-Store/Cuff-Links-Watches-and-Jewelry/Watches/Fashion/shop/_/N-52fo1l/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306421113?category=250",
               "http://www.saksfifthavenue.com/The-Men-s-Store/Cuff-Links-Watches-and-Jewelry/Watches/Fine/shop/_/N-52fo1k/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306421112?category=250",
               "http://www.saksfifthavenue.com/The-Men-s-Store/Grooming-and-Fragrance/Cologne-and-Aftershave/shop/_/N-52jun0/Ne-6lvnb5?category=262",
               "http://www.saksfifthavenue.com/Just-Kids/Baby-(0-24-Months)/Newborn-(0-9-Months)/Footies-and-Rompers/shop/_/N-52foah/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306421433?category=272",
               "http://www.saksfifthavenue.com/Just-Kids/Baby-(0-24-Months)/Newborn-(0-9-Months)/Bodysuits/shop/_/N-52foai/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306421434?category=272",
               "http://www.saksfifthavenue.com/Just-Kids/Baby-(0-24-Months)/Newborn-(0-9-Months)/Tops-and-Bottoms/shop/_/N-52foak/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306421436?category=330",
               "http://www.saksfifthavenue.com/Just-Kids/Baby-(0-24-Months)/Newborn-(0-9-Months)/Gowns/shop/_/N-52fufx/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306429405?category=272",
               "http://www.saksfifthavenue.com/Just-Kids/Baby-(0-24-Months)/Newborn-(0-9-Months)/Accessories/shop/_/N-52g004/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306436612?category=330",
               "http://www.saksfifthavenue.com/Just-Kids/Baby-(0-24-Months)/Newborn-(0-9-Months)/Blankets/shop/_/N-52g38g/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306440800?category=330",
               "http://www.saksfifthavenue.com/Just-Kids/Baby-(0-24-Months)/Newborn-(0-9-Months)/Bath-Time/shop/_/N-52g38f/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306440799?category=330",
               "http://www.saksfifthavenue.com/Just-Kids/Baby-(0-24-Months)/Newborn-(0-9-Months)/Gifts-Sets-and-Keepsakes/shop/_/N-52fqgz/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306424259?category=330",
               "http://www.saksfifthavenue.com/Just-Kids/Baby-(0-24-Months)/Baby-Girl-(0-24-Months)/Complete-Outfits/shop/_/N-52fzof/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306436191?category=330",
               "http://www.saksfifthavenue.com/Just-Kids/Baby-(0-24-Months)/Baby-Girl-(0-24-Months)/Dresses/shop/_/N-52foad/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306421429?category=330",
               "http://www.saksfifthavenue.com/Just-Kids/Baby-(0-24-Months)/Baby-Girl-(0-24-Months)/Footies-and--Rompers/shop/_/N-52fphm/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306422986?category=272",
               "http://www.saksfifthavenue.com/Just-Kids/Baby-(0-24-Months)/Baby-Girl-(0-24-Months)/Tops/shop/_/N-52fzog/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306436192?category=330",
               "http://www.saksfifthavenue.com/Just-Kids/Baby-(0-24-Months)/Baby-Girl-(0-24-Months)/Bottoms/shop/_/N-52fzoh/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306436193?category=330",
               "http://www.saksfifthavenue.com/Just-Kids/Baby-(0-24-Months)/Baby-Girl-(0-24-Months)/Outerwear/shop/_/N-52foaf/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306421431?category=286",
               "http://www.saksfifthavenue.com/Just-Kids/Baby-(0-24-Months)/Baby-Girl-(0-24-Months)/Beachwear/shop/_/N-52foov/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306421951?category=330",
               "http://www.saksfifthavenue.com/Just-Kids/Baby-(0-24-Months)/Baby-Girl-(0-24-Months)/Socks-and-Tights/shop/_/N-52fzvq/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306436454?category=289",
               "http://www.saksfifthavenue.com/Just-Kids/Baby-(0-24-Months)/Baby-Girl-(0-24-Months)/Pajamas/shop/_/N-52g4ox/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306442689?category=291",
               "http://www.saksfifthavenue.com/Just-Kids/Baby-(0-24-Months)/Baby-Girl-(0-24-Months)/Christening/shop/_/N-52ftpu/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306428466?category=330",
               "http://www.saksfifthavenue.com/Just-Kids/Baby-(0-24-Months)/Baby-Girl-(0-24-Months)/Accessories/shop/_/N-52jtjx/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306614877?category=330",
               "http://www.saksfifthavenue.com/Just-Kids/Baby-(0-24-Months)/Blankets-Bath-and-Feeding/Feeding-and-Bibs/shop/_/N-52g2ad/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306439573?category=330",
               "http://www.saksfifthavenue.com/Just-Kids/Baby-(0-24-Months)/Blankets-Bath-and-Feeding/Blankets/shop/_/N-52g2ab/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306439571?category=330",
               "http://www.saksfifthavenue.com/Just-Kids/Baby-(0-24-Months)/Blankets-Bath-and-Feeding/Bath/shop/_/N-52g2ac/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306439572?category=330",
               "http://www.saksfifthavenue.com/Just-Kids/Baby-(0-24-Months)/Shoes-and-Socks/Girls/shop/_/N-52fzoq/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306436202?category=289",
               "http://www.saksfifthavenue.com/Just-Kids/Baby-(0-24-Months)/Shoes-and-Socks/Boys/shop/_/N-52fzor/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306436203?category=289",
               "http://www.saksfifthavenue.com/Just-Kids/Baby-(0-24-Months)/Strollers-and-More/shop/_/N-52fzon/Ne-6lvnb5?category=326",
               "http://www.saksfifthavenue.com/Just-Kids/Girls-(Sizes-2-14)/Jewelry-Bags-and-Accessories/Accessories/shop/_/N-52g2ap/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306439585?category=330",
               "http://www.saksfifthavenue.com/Just-Kids/Girls-(Sizes-2-14)/Jewelry-Bags-and-Accessories/Jewelry/shop/_/N-52g2a9/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306439569?category=330",
               "http://www.saksfifthavenue.com/Just-Kids/Girls-(Sizes-2-14)/Jewelry-Bags-and-Accessories/Bags/shop/_/N-52g2aa/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306439570?category=330",
               "http://www.saksfifthavenue.com/Just-Kids/Girls-(Sizes-2-14)/Girls-(7-14)/Complete-Outfits/shop/_/N-52fzpv/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306436243?category=330",
               "http://www.saksfifthavenue.com/Just-Kids/Girls-(Sizes-2-14)/Girls-(7-14)/Dresses/shop/_/N-52fx25/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306432797?category=330",
               "http://www.saksfifthavenue.com/Just-Kids/Girls-(Sizes-2-14)/Girls-(7-14)/Tops/shop/_/N-52fzpw/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306436244?category=330",
               "http://www.saksfifthavenue.com/Just-Kids/Girls-(Sizes-2-14)/Girls-(7-14)/Bottoms/shop/_/N-52fzpx/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306436245?category=330",
               "http://www.saksfifthavenue.com/Just-Kids/Girls-(Sizes-2-14)/Girls-(7-14)/Outerwear/shop/_/N-52fx29/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306432801?category=286",
               "http://www.saksfifthavenue.com/Just-Kids/Girls-(Sizes-2-14)/Girls-(7-14)/Beachwear/shop/_/N-52fyxz/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306435239?category=330",
               "http://www.saksfifthavenue.com/Just-Kids/Girls-(Sizes-2-14)/Girls-(7-14)/Socks-and-Tights/shop/_/N-52fxc5/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306433157?category=289",
               "http://www.saksfifthavenue.com/Just-Kids/Girls-(Sizes-2-14)/Shoes-and-Socks/Child-(4-and-up)/shop/_/N-52g2a8/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306439568?category=289",
               "http://www.saksfifthavenue.com/Just-Kids/Girls-(Sizes-2-14)/Shoes-and-Socks/Toddler-(2-4)/shop/_/N-52g2a7/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306439567?category=289",
               "http://www.saksfifthavenue.com/Just-Kids/Girls-(Sizes-2-14)/Girls-(2-6)/Complete-Outfits/shop/_/N-52fzoz/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306436211?category=330",
               "http://www.saksfifthavenue.com/Just-Kids/Girls-(Sizes-2-14)/Girls-(2-6)/Dresses/shop/_/N-52foav/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306421447?category=330",
               "http://www.saksfifthavenue.com/Just-Kids/Girls-(Sizes-2-14)/Girls-(2-6)/Tops/shop/_/N-52fzp3/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306436215?category=330",
               "http://www.saksfifthavenue.com/Just-Kids/Girls-(Sizes-2-14)/Girls-(2-6)/Bottoms/shop/_/N-52fzp4/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306436216?category=330",
               "http://www.saksfifthavenue.com/Just-Kids/Girls-(Sizes-2-14)/Girls-(2-6)/Outerwear/shop/_/N-52foax/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306421449?category=286",
               "http://www.saksfifthavenue.com/Just-Kids/Girls-(Sizes-2-14)/Girls-(2-6)/Beachwear/shop/_/N-52foox/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306421953?category=330",
               "http://www.saksfifthavenue.com/Just-Kids/Girls-(Sizes-2-14)/Girls-(2-6)/Pajamas/shop/_/N-52fxx1/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306433909?category=291",
               "http://www.saksfifthavenue.com/Just-Kids/Girls-(Sizes-2-14)/Girls-(2-6)/Socks-and-Tights/shop/_/N-52foay/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306421450?category=289",
               "http://www.saksfifthavenue.com/Just-Kids/Boys-(Sizes-2-14)/Boys-(2-6)/Complete-Outfits/shop/_/N-52fzp0/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306436212?category=330",
               "http://www.saksfifthavenue.com/Just-Kids/Boys-(Sizes-2-14)/Boys-(2-6)/Tops/shop/_/N-52fzp6/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306436218?category=330",
               "http://www.saksfifthavenue.com/Just-Kids/Boys-(Sizes-2-14)/Boys-(2-6)/Bottoms/shop/_/N-52fzp7/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306436219?category=330",
               "http://www.saksfifthavenue.com/Just-Kids/Boys-(Sizes-2-14)/Boys-(2-6)/Outerwear/shop/_/N-52foat/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306421445?category=286",
               "http://www.saksfifthavenue.com/Just-Kids/Boys-(Sizes-2-14)/Boys-(2-6)/Beachwear/shop/_/N-52foow/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306421952?category=330",
               "http://www.saksfifthavenue.com/Just-Kids/Boys-(Sizes-2-14)/Boys-(2-6)/Pajamas/shop/_/N-52fxx0/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306433908?category=291",
               "http://www.saksfifthavenue.com/Just-Kids/Boys-(Sizes-2-14)/Boys-(2-6)/Accessories/shop/_/N-52foau/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306421446?category=330",
               "http://www.saksfifthavenue.com/Just-Kids/Boys-(Sizes-2-14)/Boys-(7-14)/Complete-Outfits/shop/_/N-52fzq0/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306436248?category=330",
               "http://www.saksfifthavenue.com/Just-Kids/Boys-(Sizes-2-14)/Boys-(7-14)/Tops/shop/_/N-52fzq1/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306436249?category=330",
               "http://www.saksfifthavenue.com/Just-Kids/Boys-(Sizes-2-14)/Boys-(7-14)/Bottoms/shop/_/N-52fzq2/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306436250?category=330",
               "http://www.saksfifthavenue.com/Just-Kids/Boys-(Sizes-2-14)/Boys-(7-14)/Outerwear/shop/_/N-52fxid/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306433381?category=286",
               "http://www.saksfifthavenue.com/Just-Kids/Boys-(Sizes-2-14)/Boys-(7-14)/Beachwear/shop/_/N-52fzq4/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306436252?category=330",
               "http://www.saksfifthavenue.com/Just-Kids/Boys-(Sizes-2-14)/Boys-(7-14)/Accessories/shop/_/N-52fxqr/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306433683?category=330",
               "http://www.saksfifthavenue.com/Just-Kids/Boys-(Sizes-2-14)/Shoes-and-Socks/Child-(4-and-up)/shop/_/N-52g2bt/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306439625?category=289",
               "http://www.saksfifthavenue.com/Just-Kids/Boys-(Sizes-2-14)/Shoes-and-Socks/Toddler-(2-4)/shop/_/N-52g2bs/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306439624?category=289",
               "http://www.saksfifthavenue.com/Just-Kids/Boys-(Sizes-2-14)/Scarves-Hats-and-Gloves/shop/_/N-52g4fk/Ne-6lvnb5?category=293",
               "http://www.saksfifthavenue.com/Just-Kids/Shoes-For-All-Ages/Baby-(0-24-Months)/Baby-Girl/shop/_/N-52ix0g/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306572704?category=290",
               "http://www.saksfifthavenue.com/Just-Kids/Shoes-For-All-Ages/Baby-(0-24-Months)/Baby-Boy/shop/_/N-52ix0h/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306572705?category=290",
               "http://www.saksfifthavenue.com/Just-Kids/Furniture/shop/_/N-52ja0z/Ne-6lvnb5?category=330",
               "http://www.saksfifthavenue.com/Just-Kids/Toys-and-Books/shop/_/N-52g2a1/Ne-6lvnb5?category=330",
               "http://www.saksfifthavenue.com/Just-Kids/Shoes-For-All-Ages/Boys-(2-14)/Toddler-(2-4)/shop/_/N-52ix0k/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306572708?category=290",
               "http://www.saksfifthavenue.com/Just-Kids/Shoes-For-All-Ages/Boys-(2-14)/Child-(4-and-Up)/shop/_/N-52ix0l/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306572709?category=290",
               "http://www.saksfifthavenue.com/Just-Kids/Shoes-For-All-Ages/Girls-(2-14)/Toddler-(2-4)/shop/_/N-52ix0i/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306572706?category=290",
               "http://www.saksfifthavenue.com/Just-Kids/Shoes-For-All-Ages/Girls-(2-14)/Child-(4-and-Up)/shop/_/N-52ix0j/Ne-6lvnb5?FOLDER%3C%3Efolder_id=2534374306572707?category=290"]

          list_cate.each do |link|
            FashionCrawler::Models::Resource.create({
              url: link.to_s,
              task: 'SaksfifthavenueProcessAtCatePage',
              is_visited: false,
              site_name: 'Saksfifthavenue',
              store: FashionCrawler::Models::Store.find_by(name: 'Saksfifthavenue')
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


    class SaksfifthavenueProcessAtCatePage
      def self.execute(url, body)
        doc = Nokogiri::HTML(body)

        begin
          category = url.scan(/category=(\d+)/).join("")
          doc.xpath("//a").each do |link|
            if link['href'].present? && link['href'].match(/ProductDetail/)
              detail_url = "#{link["href"]}&category=#{category}"
               unless detail_url.match(/http/)
                 detail_url = "http://www.saksfifthavenue.com" + detail_url
               end
              unless FashionCrawler::Models::Resource.where(url: detail_url).exists?
                puts "!!!!!!!!!!!!#{detail_url}!!!!!!!!!!"

                FashionCrawler::Models::Resource.create({
                url: detail_url,
                task: 'SaksfifthavenueProcessAtDetailPage',
                is_visited: false,
                site_name: 'Saksfifthavenue',
                store: FashionCrawler::Models::Store.find_by(name: 'Saksfifthavenue')
                })
              end
            end
          end

          next_link = doc.at_xpath("//a[@class='next']")
          if next_link.present?
            paging_url = "#{next_link["href"]}&category=#{category}"
            unless paging_url.match(/http/)
              paging_url = "http://www.saksfifthavenue.com" + paging_url
            end
            unless FashionCrawler::Models::Resource.where(url: paging_url).exists?
              puts "--------------------#{paging_url}----------------------!"
              FashionCrawler::Models::Resource.create({
              url: paging_url,
              task: 'SaksfifthavenueProcessAtCatePage',
              is_visited: false,
              site_name: 'Saksfifthavenue',
              store: FashionCrawler::Models::Store.find_by(name: 'Saksfifthavenue')
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

    class SaksfifthavenueProcessAtDetailPage
      def self.execute(url, body)
        doc = Nokogiri::HTML(body)
        begin
          url2 = url.gsub(/category=(.)*/, "")
          product = FashionCrawler::Models::Item.where(link: url2).first
          if product.nil?
            item = FashionCrawler::Models::Item.new
            item.link = url2
            name = doc.at_xpath("//header[@class='header sub-section clearfix']//h2")
            item.name = name.text.strip if name.present?
            brand_name_node = doc.at_xpath("//header[@class='header sub-section clearfix']//h1")
            brand_name = brand_name_node.text.strip if brand_name_node.present?

            unless brand_name.nil?
              master_brand = MasterBrand.by_brand_name(brand_name)
              unless master_brand.nil?
                item.brand_id = master_brand.brand_id
                item.brand_name = MasterBrand.id_is_other?(item.brand_id) ? brand_name : master_brand.brand_name
                item.brand_name_ja = master_brand.brand_name_ja
              end
            end

            item.site_id = 17
            item.site_name = "Saksfifthavenue"
          else
            item = product
          end

          item.description = ""
          description = doc.xpath("//span[@class='infoline']").each do |info|
            item.description << '\n' << info.text.strip
          end


          original_price = body.scan(/"list_price":"&#36;(\d+.\d+)"/)

          if original_price.present?
            original_price = original_price.first[0]
            item.original_price = "$" + original_price.strip
            item.price = CurrencyRate.convert_price_to_yen("USD", item.original_price, "$")
          end

          image = body.scan(/"shop_the_look_image":"(\d+_\d+x\d+.jpg)"/).first[0]
          item.images = "http://image.s5a.com/is/image/saks/" + image if image.present?

          category = url.scan(/category=(\d+)/).join('')
          item.category_id = category
          master_category = MasterCategory.by_category_3_id(category.to_i)
          unless master_category.nil?
            item.category_name = master_category.category_3
            general_category_id = master_category.general_category_id
          end

          sizes = []
          doc.xpath("//span[@class='value-container']").each do |span|
            sizes << span.text.strip
          end

          unless sizes.present?
            doc.xpath("//div[@class='body']").each do |div|
               list_sizes = Nokogiri::HTML(div.inner_html)
               if list_sizes.at_xpath("//a[@class='item size']").present?
                 list_sizes.xpath("//a[@class='item size']").each do |link|
                   sizes << link.text.strip
                 end
               end
               break if sizes.present?
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

          number_of_products = 0
          total_sold_out = body.scan(/\"status_label\"\:\"Sold Out/).try(:count)



          if total_sold_out.try(:to_i) < sizes.try(:count)
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
