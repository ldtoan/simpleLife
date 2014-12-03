# coding: utf-8
require File.expand_path(File.dirname(__FILE__)) + '/yaml_base_with_code.rb'
class CurrencyRate < YAMLBaseWithCode
  set_file(File.dirname(__FILE__) + "/master_db/currency_rate.yml")

  def rate
    data[0].to_i
  end

  def currency
    self.id.to_s
  end

  class << self
    def all
      return @all_currencies if @all_currencies
      @all_currencies = super.sort_by{|c| c.id}
    end

    def by_name(name)
      all.detect{|o|
        name == o.category
      }
    end

    def convert_to_yen(currency,number)
      rate = all.detect{|o| currency == o.currency}.rate
      return number * rate
    end

    def convert_price_to_yen(currency,price,sign)
      price = price.gsub(sign, "").gsub(/,|\s/, "").to_f
      rate = all.detect{|o| currency == o.currency}.rate
      return price * rate
    end

    def by_name_include(name)
      all.detect{|o|
        name.include?(o.category)
      }
    end
  end

end
