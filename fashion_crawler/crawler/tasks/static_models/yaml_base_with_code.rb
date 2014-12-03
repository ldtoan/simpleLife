require File.expand_path(File.dirname(__FILE__)) + '/yaml_base.rb'
class YAMLBaseWithCode < YAMLBase

  def code
    data[0]
  end

  class << self

    def find_by_code code
      datas.each{|k, v|
        return new(k) if(v[0] == code)
      }
      return nil
    end

    def [] str
      str = str.to_s
      if str.to_s =~ /^\d+$/
        find str
      else
        find_by_code str
      end
    end

  end

end
YamlBaseWithCode = YAMLBaseWithCode