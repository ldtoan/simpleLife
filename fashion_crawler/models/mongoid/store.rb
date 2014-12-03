# coding: utf-8
# this template contains just url sone basic info about the website target

require 'mongoid'
require File.expand_path(File.dirname(__FILE__)) + '/resource'
require File.expand_path(File.dirname(__FILE__)) + '/store'
require File.expand_path(File.dirname(__FILE__)) + '/crawl-log'

module FashionCrawler
  module Models
    class Store
      include Mongoid::Document

      field :name
      field :url
      field :hourly_limit, type: Integer, default: 0
      field :parallel_request_limit, type: Integer, default: 0
      field :crawling, type: Boolean
      field :site_id, type: Integer
      field :importing, type: Boolean, default: false

      # has_many :pages #=> Mongoid::Errors::MixedRelations
      has_many :crawl_logs
      has_many :resources

      index name: 1
      index url: 1
      index site_id: 1

    end
  end
end


