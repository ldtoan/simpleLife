# coding: utf-8
require File.expand_path(File.dirname(__FILE__)) + '/yaml_base_with_code.rb'
class YooxCategory < YAMLBaseWithCode
  set_file(File.dirname(__FILE__) + "/master_db/yoox_category.yml")

  def category_id
    data[0].to_i
  end

  def category
    self.id
  end

  class << self
    def all
      return @all_yoox_categories if @all_yoox_categories
      @all_yoox_categories = super.sort_by{|c| c.category_id}
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

    def by_split_name(name)
      detect_cat = {}.with_indifferent_access
      split_cat = name.split(",")
      if split_cat.try(:last).include?("men")
        detect_cat[:name_cate] = "men"
      else
        detect_cat[:name_cate] = "women"
      end

      detect_cat[:category] = split_cat.try(:first).try(:downcase)
      all.each do |category_name|
        if category_name.try(:category).include?(detect_cat[:name_cate]) && category_name.try(:category).include?(detect_cat[:category])
          return category_name
        end
      end
    end
  end

end
