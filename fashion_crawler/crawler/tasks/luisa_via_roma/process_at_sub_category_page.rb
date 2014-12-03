require 'nokogiri'
require 'unicode'
require 'uri'
require 'date'
require 'open-uri'

module FashionCrawler
  module Tasks
    class LuisaViaRomaProcessAtSubCategoryPage
      attr_reader :url, :body

      def initialize(url, body)
        @url = url
        @body = body
      end

      def execute
        begin
          product_urls.each do |product_url|
            FashionCrawler::Models::Resource.create({
              url: product_url,
              task: 'LuisaViaRomaProcessAtProductPage',
              is_visited: false,
              site_name: 'LuisaViaRoma',
              store: FashionCrawler::Models::Store.find_by(name: 'LuisaViaRoma')
            })
          end
        rescue => e
          puts e.backtrace
        ensure
          FashionCrawler::Models::Resource.where(url: url).update_all(is_visited: true)
        end
      end

      private

      def product_urls
        products.map { |product| url_for_product(product) }
      end

      def products
        JSON.parse(body[/\=(.*?)\;/, 1])["CatalogResults"] rescue []
      end

      def url_for_product(product)
        "http://www.luisaviaroma.com/ItemSrv.ashx?itemRequest={%22SeasonId%22:%22#{product["SeasonId"]}%22,%22CollectionId%22:%22#{product["ItemCollectionId"]}%22,%22ItemId%22:%22#{product["ItemId"]}%22,%22VendorColorId%22:%22%22,%22SeasonMemoCode%22:%22actual%22,%22GenderMemoCode%22:%22#{product["Gender"]["MemoCode"]}%22,%22Language%22:%22%22,%22CountryId%22:%22%22,%22SubLineMemoCode%22:%22%22,%22CategoryId%22:0,%22ItemResponse%22:%22itemResponse=%22,%22MenuResponse%22:%22menuResponse%22,%22SizeChart%22:false,%22ItemTag%22:true,%22NoContext%22:false}"
      end
    end
  end
end
