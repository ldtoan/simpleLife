# coding: utf-8

require File.expand_path(File.dirname(__FILE__)) + '/crawl-manager.rb'
require File.expand_path(File.dirname(__FILE__)) + '/my-logger.rb'


def main
  FashionCrawler::CrawlManager.instance.run
end


if __FILE__ == $0
  main()
end
