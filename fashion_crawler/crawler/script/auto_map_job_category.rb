# encoding: utf-8
require 'csv'
require 'unicode'
require File.expand_path(File.dirname(__FILE__)).gsub("script","tasks") + '/static_models/category_keywords.rb'

input_file = ARGV[0]
out_file = File.open(input_file.gsub(".csv", "") + "_convert_result.csv", "w")


def split_comma(key)
  if key.include?(",")
    return key.split(",")
  else
    return key
  end
end


def print_line(out_file, line, id, sub)
  out_file.write(line + "," + id.to_s + "," + sub + "\n")
end

File.readlines(input_file).each do |line|
  line = line.gsub("\n","").downcase
  key = split_comma(line)
  if key.kind_of?(Array)
    keys = key
    result = CategoryKeywords.match_array(keys)
  else
    result = CategoryKeywords.match_key(key)
  end
  out_file.write(line + result + "\n")
end


