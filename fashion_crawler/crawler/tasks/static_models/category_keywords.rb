# encoding: utf-8
require File.expand_path(File.dirname(__FILE__)) + '/yaml_base_with_code.rb'
class CategoryKeywords < YAMLBaseWithCode
  set_file(File.dirname(__FILE__) + "/master_db/category_keywords.yml")
  BIG_CATEGORIES = ["women", "men", "kid", "baby", "maternity", "girl"]

  def category_id
    data[3].to_i
  end

  def big_category
    data[2].to_s
  end

  def keyword
    data[1].to_s
  end

  class << self
    def all
      # return @all_categories if @all_categories
      @all_category_keywords = super.sort_by{|c| -c.keyword.size}
      return @all_category_keywords
    end

    def match_array(keys)
      item = all.detect{|o| keys[0] == o.big_category && keys[1].include?(o.keyword)}
      return item.nil? ? ",,," : ",#{item.category_id},#{item.keyword},#{item.big_category}"
    end

    def match_key(key)
      big_category = ""
      BIG_CATEGORIES.each do |bc|
        if key.include?(bc)
          big_category = bc
          break
        end
      end
      if big_category != ""
        item = all.detect{|o| big_category == o.big_category && key.include?(o.keyword)}
      end
      if item.nil?
        item = all.detect{|o| o.big_category == "other" && key.include?(o.keyword)}
      end
      return item.nil? ? ",,," : ",#{item.category_id},#{item.keyword},#{item.big_category}"
    end

  end

end
