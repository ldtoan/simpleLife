# coding: utf-8
require 'mongoid'

module FashionCrawler
  module Models
    class Item
      include Mongoid::Document
      before_save :updated_at

      field :name, type: String, default: ""
      field :name_ja, type: String, default: ""
      field :brand_id, type: Integer
      field :brand_name, type:  String, default: ""
      field :brand_name_ja, type: String, default: ""
      field :material, type: String, default: ""
      field :material_ja, type: String, default: ""
      field :original_price, type: String
      field :price, type: Float
      field :original_base_price, type: String
      field :base_price, type: Float
      field :link, type: String, default: ""
      field :description, type: String, default: ""
      field :site_id, type: Integer
      field :site_name, type: String, default: ""
      field :country_id, type: Integer
      field :country_name, type: String, default: ""
      field :season, type: String, default: ""
      field :year, type: Integer
      field :category_id, type: Integer
      field :category_name, type: String
      field :original_size, type: String, default: ""
      field :size, type: String, default: ""
      field :images, type: String, default: ""
      field :colors, type: String, default: ""
      field :added_or_updated, type: Boolean, default: true
      field :updated_at, type: DateTime
      field :flag, type: Integer
      field :number_of_products, type: Integer

      index link: 1
      index site_name: 1
      index site_id: 1
      index name: 1
      index brand_name: 1

      def updated_at
        self.updated_at = DateTime.now
        self.added_or_updated = true
      end

      def valid_saved_conditions?
        name.present? && category_name.present? && flag == 1
      end
    end
  end
end
