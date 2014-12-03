# coding: utf-8
require File.expand_path(File.dirname(__FILE__)) + '/yaml_base_with_code.rb'
class MasterBrand < YAMLBaseWithCode
  set_file(File.dirname(__FILE__) + "/master_db/master_brand.yml")

  def brand_id
    self.id.to_i
  end

  def brand_name
    data[1]
  end

  def brand_name_ja
    data[2]
  end

  class << self
    def all
      return @all_brands if @all_brands
      @all_brands = super.sort_by{|c| -c.brand_name.size}
      return @all_brands
    end

    def by_brand_id(id)
      all.detect{|o|
        id.to_i == o.brand_id
      }
    end

    def by_brand_name(name)
      return nil if name.downcase == "superdry"
      brand = all.detect{|o|
        name.downcase == o.brand_name.downcase
      }
      if brand.nil?
        brand = self.by_brand_id(100000)
      end
      return brand
    end

    def by_brand_name_include(name)
      return nil if name.downcase.include?("superdry")
      name = " " + name + " "
      brand = all.detect{|o|
        name.downcase.include?(" " + o.brand_name.downcase + " ")
      }
      return brand.nil? ? self.by_brand_id(100000) : brand
    end

    def id_is_other?(brand_id)
      return brand_id == 100000 ? true : false
    end
  end

end
