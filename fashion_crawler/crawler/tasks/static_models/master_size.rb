# coding: utf-8
require File.expand_path(File.dirname(__FILE__)) + '/yaml_base_with_code.rb'
class MasterSize < YAMLBaseWithCode
  set_file(File.dirname(__FILE__) + "/master_db/master_size.yml")

  SIZE_TEXT = {
    "small" => "S",
    "medium" => "M",
    "large" => "L",
    "extra" => "X"
  }
  COUNTRIES = ["UK", "US", "EU"]

  def size_id
    data[0].to_i
  end

  def general_category_id
    data[1]
  end

  def country
    data[3]
  end

  def original_size
    data[4]
  end

  def convert_size
    data[5]
  end

  class << self
    def all
      return @all_sizes if @all_sizes
      @all_sizes = super.sort_by{|c| c.id}
      return @all_sizes
    end

    def by_size_id(id)
      all.detect{|o|
        id.to_i == o.size_id
      }
    end

    def convert_size(original,country,general_category_id)
      all.detect{|o|
        original.downcase == o.original_size && country == o.country && general_category_id == o.general_category_id
      }
    end

    def convert_sizes(original_size,country,general_category_id)
      return "" if original_size.blank?
      sizes = original_size.split(",")
      converted_sizes = []
      sizes.each do |size|
        converted_size = convert_size(size,country,general_category_id)
        return original_size if converted_size.nil?
        converted_sizes << converted_size.convert_size
      end
      return "JP " + converted_sizes.join(",")
    end

    def standardize_size(size)
      size = size.gsub(" ", "")
      SIZE_TEXT.each do |text, standard|
        size = size.gsub(/#{text}/i, standard)
      end
      return size
    end

    def new_size_country(text)
      ct = nil
      COUNTRIES.each do |country|
        if text.include?(country)
          text = text.gsub(country, "")
          ct = country
          next
        end
      end
      return text,ct
    end

    def get_country(text)
      result = ""
      COUNTRIES.each do |country|
        result = country if text.include?(country)
      end
      return result
    end
  end

end
