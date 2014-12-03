require 'nokogiri'
require 'unicode'
require 'uri'
require 'date'
require 'open-uri'

module FashionCrawler
  module Tasks
    class LuisaViaRomaProcessAtProductPage
      BASE_IMAGE_URL = 'http://images.luisaviaroma.com/Big'
      attr_reader :url, :body

      def initialize(url, body)
        @url = url
        @body = body
      end

      def execute
        begin
          @item = FashionCrawler::Models::Item.find_or_initialize_by(link: actual_url)

          if @item.new_record?
            build_item
            save_item
          end
        rescue => e
          puts e.backtrace
        ensure
          FashionCrawler::Models::Resource.where(url: url).update_all(is_visited: true)
        end
      end

      private

      def build_item
        @item.attributes = item_params
        set_brand_for_item if brand_name.present?
        set_category_for_item
        set_size_for_item if size.present?
      end

      def save_item
        if @item.valid_saved_conditions?
          @item.save!
          puts "added #{@item.name}"
        end
      end

      def set_brand_for_item
        master_brand = MasterBrand.by_brand_name(brand_name)

        if master_brand
          @item.brand_id = master_brand.brand_id
          @item.brand_name = MasterBrand.id_is_other?(@item.brand_id) ? brand_name : master_brand.brand_name
          @item.brand_name_ja = master_brand.brand_name_ja
        end
      end

      def set_category_for_item
        @item.category_id = LuisaviaromaCategory.find_by_short_url(category_short_url).try(:category_id)

        if master_category
          @item.category_name = master_category.category_3
        end
      end

      def set_size_for_item
        @item.original_size = size

        if master_category && master_category.general_category_id
          @item.size = MasterSize.convert_sizes(@item.original_size, 'US', master_category.general_category_id)
        else
          @item.size = @item.original_size
        end
      end

      def master_category
        MasterCategory.by_category_3_id(@item.category_id)
      end

      def item_params
        {
          name: name, site_id: 27, site_name: 'LuisaViaRoma',
          description: description, original_price: original_price, colors: colors,
          images: images, flag: flag, number_of_products: number_of_products
        }
      end

      def actual_url
        "http://www.luisaviaroma.com/index.aspx#ItemSrv.ashx|SeasonId=#{product["ItemKey"]["SeasonId"]}&CollectionId=#{product["ItemKey"]["CollectionId"]}&ItemId=#{product["ItemKey"]["ItemId"]}&SeasonMemoCode=actual&GenderMemoCode=#{gender}&CategoryId=&SubLineId=#{subline}"
      end

      def category_short_url
        "#{gender},#{subline}/#{category}"
      end

      def gender
        product["Gender"]["MemoCode"]
      end

      def subline
        product["SubLine"]["MemoCode"]
      end

      def category
        product["Category"]["Description"].parameterize
      end

      def name
        product["ShortDescription"].try(:strip)
      end

      def brand_name
        product["Designer"]["Description"].try(:strip)
      end

      def description
        product["LongtDescription"].try(:strip)
      end

      def original_price
        "#{product["Pricing"].first["Prices"].first["CurrencyId"]} #{product["Pricing"].first["Prices"].first["FinalPrice"]}"
      end

      def images
        product["ItemPhotos"].map { |item| BASE_IMAGE_URL + item["Path"] }.join(',')
      end

      def size
        product["ItemAvailability"].map { |item| item["SizeValue"] }.join(',')
      end

      def colors
        parsed_colors = product["ItemAvailability"].map do |item|
          item["ColorAvailability"].map { |color| color["ComColorDescription"].gsub(/\//, ' ') }
        end.flatten.uniq

        parsed_colors.map { |color| Color.find_by_name(color).name }.join(',')
      end

      def flag
        product["ItemAvailability"].any? ? 1 : 0
      end

      def number_of_products
        product["MaxOrderQuantity"].to_i * product["ItemAvailability"].size
      end

      def product
        JSON.parse(body[/\=(.*?)\;/, 1]) rescue return
      end
    end
  end
end
