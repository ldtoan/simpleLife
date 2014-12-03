# coding: utf-8
require 'mongoid'

module FashionCrawler
  module Models
    class Author
      include Mongoid::Document
      before_save :updated_at

      field :name, type: String, default: ""
      field :link, type: String, default: ""
      field :description, type: String, default: ""
      field :site_id, type: Integer
      field :site_name, type: String, default: ""
      field :country, type: String
      field :image, type: String, default: ""
      field :added_or_updated, type: Boolean, default: true
      field :updated_at, type: DateTime

      index link: 1
      index site_name: 1
      index site_id: 1
      index name: 1

      def updated_at
        self.updated_at = DateTime.now
        self.added_or_updated = true
      end

    end
  end
end
