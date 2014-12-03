require 'yaml'

class YAMLBase
  attr_reader :id

  def initialize id
    @id = id
    if self.class.datas.kind_of?(Hash)
      @data = self.class.datas[@id]
    else
      @data = self.class.datas.find{|o| o[0] == @id}
    end

    raise ArgumentError unless @data
  end

  def id
    @id
  end

  def data
    @data
  end

  def == obj
    return false unless obj.is_a?(self.class)

    return self.id == obj.id
  end

  def === obj
    return false unless obj.is_a?(self.class)
    return self.id === obj.id
  end

  class << self
    def datas
      return @datas if @datas


      @datas = YAML.load_file(@file)
    end

    def find id
      id = id.to_s unless id.kind_of?(String)
      new(id)
    rescue ArgumentError
      raise NotFound
    end

    def all
      return @all if @all

      @all = (datas.kind_of?(Hash)) ?
        datas.keys.sort.map{|id| find(id)} :
        datas.map{|d| find(d[0])}
    end

#    def codes
#      all.map{|o| o.code}
#    end
#
#    def check_code(code)
#      self.codes.include?(code)
#    end

    def set_file file_name
      @file = file_name
      @all = nil
      @datas = nil
    end

    def [] str
      find(str)
    end

  end

  class NotFound < StandardError
  end
end
YamlBase = YAMLBase
