# encoding: utf-8
require 'nokogiri'
require 'unicode'
require 'uri'
require 'net/http'
require 'date'

module FashionCrawler
  module Tasks
    class ZingProcessAtMainPage
     def self.execute(url, body)
      begin
        file_path = File.dirname(__FILE__) + "/static_models/master_db/zing.yml"
        f = File.open(file_path, "r")
        f.each_line do |line|
          FashionCrawler::Models::Resource.create({
            url: line,
            task: 'ZingProcessAtListSinger',
            is_visited: false,
            site_name: 'Zing',
            store: FashionCrawler::Models::Store.find_by(name: 'Zing')
          })
        end
        f.close
      rescue => e
        puts e.inspect
        puts e.backtrace
      ensure
          #change the link status
          FashionCrawler::Models::Resource.where(url: url).update_all(is_visited: true)
      end
     end
    end

    class ZingProcessAtListSinger
      def self.execute(url, body)
        doc = Nokogiri::HTML(body)
        begin
          doc.xpath("//div[@class='content-block']//div[@class='singer-block-item']").each do |singer|
            singer = Nokogiri::HTML(singer.inner_html)
            singer_name = singer.at_xpath("//h3")
            singer_image = singer.at_xpath("//span[@class='new-singer-img']//a//img")
            singer_desc = singer.at_xpath("//p")
            singer_link = singer_name = singer.at_xpath("//h3//a")
            singer = FashionCrawler::Models::Singer.new
            singer.name = singer_name.text if singer_name.present?
            singer.image = singer_image["src"] if singer_image.present?
            singer.link =  "http://mp3.zing.vn" + singer_link["href"] + "/bai-hat"
            singer.description = singer_desc.text if singer_desc.present?

            ###########################################################################
            if singer.name.present?
              unless FashionCrawler::Models::Singer.where(name: singer.name).exists?
                singer.save!
                puts "\Added singer: #{singer.name}"
              end
            end
            ############################################################################

            FashionCrawler::Models::Resource.create({
            url: singer.link,
            task: 'ZingProcessAtListSong',
            is_visited: false,
            site_name: 'Zing',
            store: FashionCrawler::Models::Store.find_by(name: 'Zing')
            })
          end

          next_link = doc.at_xpath("//a[@title='Trang sau']")
          if next_link.present?
            next_page = "http://mp3.zing.vn" + next_link["href"]
            FashionCrawler::Models::Resource.create({
              url: next_page,
              task: 'ZingProcessAtListSinger',
              is_visited: false,
              site_name: 'Zing',
              store: FashionCrawler::Models::Store.find_by(name: 'Zing')
            })
          end
        rescue => e
          puts e.inspect
          puts e.backtrace
        ensure
          #change the link status
          FashionCrawler::Models::Resource.where(url: url).update_all(is_visited: true)
        end
      end
    end

    class ZingProcessAtListSong
      def self.execute(url, body)
        doc = Nokogiri::HTML(body)
        begin
          doc.xpath("//ul[@class='song-list']//h2[@class='song-name']//a").each do |song|
            detail_url = "http://mp3.zing.vn" + song["href"]
            unless FashionCrawler::Models::Singer.where(name: detail_url).exists?
              puts "!!!!!!!!!!!!!!!!!#{detail_url}!!!!!!!!!!!!!!!!!!!!!"
              FashionCrawler::Models::Resource.create({
                url: detail_url,
                task: 'ZingProcessAtDetailSong',
                is_visited: false,
                site_name: 'Zing',
                store: FashionCrawler::Models::Store.find_by(name: 'Zing')
              })
            end
          end
          next_link = doc.at_xpath("//a[@title='Trang sau']")
          if next_link.present?
            next_page = "http://mp3.zing.vn" + next_link["href"].gsub(/\/ajax/, "")
            puts "-------------#{next_page}---------------"
            FashionCrawler::Models::Resource.create({
              url: next_page,
              task: 'ZingProcessAtListSong',
              is_visited: false,
              site_name: 'Zing',
              store: FashionCrawler::Models::Store.find_by(name: 'Zing')
            })
          end

        rescue => e
          FashionCrawler::Models::Resource.where(url: url).update_all(is_visited: true)
          puts e.inspect
          puts e.backtrace
        ensure
          #change the link status
          FashionCrawler::Models::Resource.where(url: url).update_all(is_visited: true)
        end
      end
    end

    class ZingProcessAtDetailSong
      def self.execute(url, body)
        doc = Nokogiri::HTML(body)
        begin
          song = FashionCrawler::Models::Song.new
          ########################################################################
          parse_music = doc.css("script")
          if parse_music.present?
            get_content = ""
            parse_music.each do |script|
              if script.content.include?("http://mp3.zing.vn/xml/song-xml/")
                get_content = script.content
                break
              end
            end
            if get_content.present?
              response_link = get_content.scan(/http\:\/\/mp3\.zing\.vn\/xml\/song\-xml\/[a-zA-Z]+/).try(:first)
            end

            if response_link.present?
              begin
                uri = URI(response_link)
                request = Net::HTTP::Get.new(uri.request_uri)
                response = Net::HTTP.get_response(uri)
                get_real_link = response.body.squish.scan(/http:\/\/mp3.zing.vn\/xml\/load-song\/\w+=/).try(:first)
                song.src = get_real_link.to_s
              rescue => e
                puts e.inspect
                puts e.backtrace
              end
            end
          end
          ######################################################################################################
          song.link = url
          name = doc.at_xpath("//div[@class='detail-content']//div[@class='detail-content-title']//h1")
          song.name = name.text.strip if name.present?
          singer = doc.at_xpath("//div[@class='detail-content']//div[@class='detail-content-title']//h2")
          song.singer = singer.text.strip if singer.present?

          song_info = doc.at_xpath("//div[@class='detail-content']//p[@class='song-info']")
          song_info.text.split("|").each do |str|
            if str.to_s.match(/Sáng tác:/)
              song.author = str.gsub("Sáng tác:", "").strip
            elsif str.to_s.match(/Album:/)
              song.album = str.gsub("Album:", "").strip
            end
          end

          category = doc.xpath("//div[@class='detail-content']//p[@class='song-info']//a").last
          song.category = category.text if category.present?

          #############################################################################
          author = FashionCrawler::Models::Author.new
          author.name = song.author
          author.link = url
          unless FashionCrawler::Models::Author.where(name: author.name).exists?
            author.save! unless song.author.to_s.match(/Đang cập nhật/)
          end

          album = FashionCrawler::Models::Album.new
          album.name = song.album
          album.link = url
          unless FashionCrawler::Models::Album.where(name: album.name).exists?
            album.save!
          end

          category = FashionCrawler::Models::Category.new
          category.name = song.category
          category.link = url
          unless FashionCrawler::Models::Category.where(name: category.name).exists?
            category.save!
          end
          ##############################################################################
          song.save!
          puts "\Added song: #{url}"
        rescue => e
          FashionCrawler::Models::Resource.where(url: url).update_all(is_visited: true)
          puts e.inspect
          puts e.backtrace
        ensure
          #change the link status
          FashionCrawler::Models::Resource.where(url: url).update_all(is_visited: true)
        end
      end
    end

  end
end
