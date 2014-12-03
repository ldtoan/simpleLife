# coding: utf-8
# store log of db

require 'mongoid'

module FashionCrawler
  module Models
    class CrawlLog
      include Mongoid::Document

      field :date, type: DateTime
      field :count, type: Integer, default: 0

      belongs_to :store

      index date: 1

    end
  end
end


