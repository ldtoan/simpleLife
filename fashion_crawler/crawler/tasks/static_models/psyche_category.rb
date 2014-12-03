# coding: utf-8
require File.expand_path(File.dirname(__FILE__)) + '/yaml_base_with_code.rb'
class PsycheCategory < YAMLBaseWithCode
  set_file(File.dirname(__FILE__) + "/master_db/psyche_category.yml")

  def category_id
    data[0].to_i
  end

  def category
    self.id
  end

  class << self
    def all
      return @all_psyche_categories if @all_psyche_categories
      @all_psyche_categories = super.sort_by{|c| c.category_id}
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
      detect_cat = {}
      detect_cat[:name_cate] = name.include?("mens") ? "mens" : ""
      detect_cat[:name_cate] = name.include?("womens") ? "womens" : ""
      detect_cat[:name_cate] = name.include?("kids") ? "kids" : ""

      if name.include?("#,p:")
        detect_cat[:child_cat] = name.split("#,p:").try(:last)
      elsif name.include?("?p=")
        detect_cat[:child_cat] = name.split("?p=").try(:first)
      else
        detect_cat[:child_cat] = name
      end

      all.each do |category_name|
        if category_name.try(:category).include?(detect_cat[:name_cate]) && category_name.try(:category).include?(detect_cat[:child_cat])
          return category_name
        end
      end
    end
  end

end
