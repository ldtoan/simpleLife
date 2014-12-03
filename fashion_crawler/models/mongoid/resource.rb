# coding: utf-8
# stores info of each category and its ad
# information about the url, task, id

require 'mongoid'

module FashionCrawler
  module Models
    class Resource
      include Mongoid::Document

      field :url
      field :task
      field :last_access, type: DateTime
      field :is_visited, type: Boolean
      field :site_name
      field :category_name_url
      #detail about post/get method and parameters, if nil default get
      #struture: method: POST/GET, params: {...}
      field :detail, type: Hash
      belongs_to :store

      index url: 1
      index last_access: 1
      index site_name: 1

    end
  end
end

