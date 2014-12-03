require 'nokogiri'
require 'unicode'
require 'uri'
require 'date'
require 'open-uri'

module FashionCrawler
  module Tasks
    class LuisaViaRomaProcessAtCategoryPage
      attr_reader :url, :body

      def initialize(url, body)
        @url = url
        @body = body
      end

      def execute
        begin
          subcategory_urls.each do |subcategory_url|
            FashionCrawler::Models::Resource.create({
              url: subcategory_url,
              task: 'LuisaViaRomaProcessAtSubCategoryPage',
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

      def subcategory_ids
        subcategories.map { |subcategory| subcategory["Id"] }
      end

      def subcategories
        JSON.parse(body[/\=(.*?)\;/, 1])["CategoryItems"] rescue []
      end

      def gender
        url[/Gender\%22:\%22(.*?)\%22/, 1]
      end

      def subline
        url[/Subline\%22:\%22(.*?)\%22/, 1]
      end

      def subcategory_urls
        subcategory_ids.map { |subcategory_id| url_for_subcategory(subcategory_id) }
      end

      def url_for_subcategory(subcategory_id)
        "http://www.luisaviaroma.com/CatalogSrv.ashx?data={%22Season%22:%22actual%22,%22Gender%22:%22#{gender}%22,%22Age%22:%22%22,%22SubLine%22:%22#{subline}%22,%22DesignerId%22:%22%22,%22CategoryId%22:#{subcategory_id},%22ItemSeasonId%22:%22%22,%22ItemCollectionId%22:%22%22,%22ItemId%22:0,%22ColorId%22:%22%22,%22FromSearch%22:false,%22PriceRange%22:%22%22,%22Discount%22:%22%22,%22SizeTypeId%22:%22%22,%22SizeId%22:%22%22,%22Available%22:false,%22NewArrivals%22:false,%22ListaId%22:%22%22,%22ViewExcluded%22:false,%22IsMobile%22:false,%22MenuDataCallback%22:%22%22,%22NewArrivalsAutomatic%22:true,%22MaxItemXPage%22:48,%22ResponseTypeString%22:%22TextToEval%22}"
      end
    end
  end
end
