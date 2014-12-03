# encoding: utf-8
require 'mongoid'
require 'csv'
require 'logger'
require "activerecord-import/base"
file_path = File.dirname(__FILE__).gsub(/lib\/tasks/, "")
Dir[File.expand_path(file_path) + '/fashion_crawler/models/mongoid/*.rb'].each {|file| require file }
Mongoid.load!(File.expand_path(file_path) + '/fashion_crawler/crawler/config/mongoid.yml', :production)

namespace :crawler do
  log = Logger.new("log/songs_import_rake.log", 'daily')
  desc "Import items from mongodb"
  product_color_columns = [:product_id, :color_id, :color_name]
  product_image_columns = [:product_id, :image_link, :image_type]
  task :import_songs => :environment do
    begin
      puts "Importing   ................"
      start_time = Time.now

      count = FashionCrawler::Models::Song.all.count
      log.info("Will be importing #{count} songs")
      FashionCrawler::Models::Song.all.no_timeout.each do |record|
        CrawlImport::Import.new.import_record(record, log)
      end
    rescue => e
        log.error("fail to import product")
        log.error(e.inspect)
    end
  end
end

module CrawlImport
  class Import
    def import_record(record, log)
      begin
        existing_song = Song.find_by(link: record['link'])
        if existing_song.nil?
          song = Song.new
          song.link = record['link']
        else
          song = existing_song
        end
        song.name        = record['name']
        song.category = record['category']
        song.album = record['album']
        song.singer = record['singer']
        song.link = record['link']
        song.src = record['src']
        song.updated_at = record['updated_at']

        song.save!
        puts song.name
        if existing_song.nil?
          log.info("song name: #{song.name} added")
        else
          log.info("song name: #{song.id} updated")
        end

      rescue => e
        log.error("fail to import product")
        log.error(e.inspect)
      end
    end
  end
end