require 'nokogiri'
require 'unicode'
require 'uri'
require 'date'
require 'open-uri'

module FashionCrawler
  module Tasks
    class LuisaViaRomaProcessAtMainPage
      ADULT_GENDERS = ['men', 'women']
      ADULT_SUBLINES = ['clothing', 'bags', 'shoes', 'accessories', 'fine_jewellery', 'fashion_jewellery', 'sport']
      attr_reader :url, :body

      def initialize(url, body)
        @url = url
        @body = body
      end

      def execute
        begin
          category_urls.each do |category_url|
            FashionCrawler::Models::Resource.create({
              url: category_url,
              task: 'LuisaViaRomaProcessAtCategoryPage',
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

      def category_urls
        ADULT_GENDERS.collect { |adult_gender|
          ADULT_SUBLINES.collect { |adult_subline| url_for_category(adult_gender, adult_subline) }
        }.flatten
      end

      def url_for_category(gender, subline)
        "http://www.luisaviaroma.com/CategorySrv.ashx?categoryrequest={%22Season%22:%22actual%22,%22Gender%22:%22#{gender}%22,%22Subline%22:%22#{subline}%22}"
      end
    end
  end
end
