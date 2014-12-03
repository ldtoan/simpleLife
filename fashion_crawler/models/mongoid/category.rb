# coding: utf-8
require 'mongoid'

module FashionCrawler
  module Models
    class Category
      include Mongoid::Document
      before_save :updated_at

      field :name, type: String, default: ""
      field :link, type: String, default: ""
      field :images, type: String, default: ""
      field :colors, type: String, default: ""
      field :added_or_updated, type: Boolean, default: true
      field :updated_at, type: DateTime
      field :flag, type: Integer

      def updated_at
        self.updated_at = DateTime.now
        self.added_or_updated = true
      end

    end
  end
end
