require File.expand_path(File.dirname(__FILE__)) + '/yaml_base_with_code.rb'

class LuisaviaromaCategory < YAMLBaseWithCode
  set_file(File.dirname(__FILE__) + "/master_db/luisaviaroma_category.yml")

  def category_id
    data[0].to_i
  end

  def self.all
    super.sort_by{ |category| category.category_id }
  end

  def self.find_by_short_url(short_url)
    all.detect { |category| category.id == short_url }
  end
end
