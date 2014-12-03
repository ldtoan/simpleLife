# coding: utf-8
require File.expand_path(File.dirname(__FILE__)) + '/yaml_base_with_code.rb'
class Color < YAMLBaseWithCode
  set_file(File.dirname(__FILE__) + "/master_db/colors.yml")

  OTHER_COLOR_ID = 1000

  def id
    data[0].to_i
  end

  def name
    data[1]
  end

  def name_ja
    data[2]
  end

  class << self
    def all
      # return @all if @all
      @all = super.sort_by{|c| c.id}
      return @all
    end

    def by_id(id)
      all.detect{|o|
        id == o.id
      }
    end

    def by_name(name)
      color = all.detect{|o|
        name.downcase == o.name
      }
      if color.nil?
        color = self.by_id(OTHER_COLOR_ID)
      end
      return color
    end

    def crawler_extract_color_name(name)
      color = all.detect{|o|
        name.downcase.include?(o.name)
      }
      return color.nil? ? "" : color.name
    end

    def find_by_name(name)
      all.detect{ |color| color.name == name.downcase } || by_id(OTHER_COLOR_ID)
    end

  end

end
