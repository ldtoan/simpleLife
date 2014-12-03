# coding: utf-8
require File.expand_path(File.dirname(__FILE__)) + '/yaml_base_with_code.rb'
class ShopbopCategory < YAMLBaseWithCode
  set_file(File.dirname(__FILE__) + "/master_db/shopbop_category.yml")

  def category_id
    data[0].to_i
  end

  def category
    self.id
  end

  class << self
    def all
      return @all_shopbop_categories if @all_shopbop_categories
      @all_shopbop_categories = super.sort_by{|c| c.category_id}
    end

    def by_name(name)
      all.detect{|o|
        name == o.category
      }
    end

    def by_name_include(name)
      all.detect{|o|
        name.include?(o.category)
      }
    end
  end

end
