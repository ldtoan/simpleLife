# encoding: utf-8
require File.expand_path(File.dirname(__FILE__)) + '/yaml_base_with_code.rb'
class MasterCategory < YAMLBaseWithCode
  set_file(File.dirname(__FILE__) + "/master_db/master_category.yml")

  def category_id
    data[0].to_i
  end

  def category_1_id
    data[6].to_i
  end

  def category_2
    data[4]
  end

  def category_2_id
    data[5].to_i
  end

  def category_3
    data[1]
  end

  def category_3_id
    data[2].to_i
  end

  def general_category_id
    data[3]
  end

  class << self
    def all
      # return @all_categories if @all_categories
      @all_categories = super.sort_by{|c| c.category_id}
      return @all_categories
    end

    def by_category_3_id(id)
      all.detect{|o| id == o.category_3_id
      }
    end

  end

end
