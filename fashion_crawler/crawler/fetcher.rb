# coding: utf-8

require 'singleton'
require 'eventmachine'
require 'em-http-request'
require File.expand_path(File.dirname(__FILE__)) + '/my-logger'
SITES = ["karmaloop", "saksfifthavenue", "asos", "coggles", "yoox", 'luisaviaroma', "neimanmarcus"]

module FashionCrawler
  class Fetcher
    include Singleton

    @@max_parallel_request = 5

    # {url, store_name, &callback}
    @@pending_urls = []

    @@requesting_url = []

    @@fetched_urls = []

    @@failed_url = []

    # add_queue(url){ |body| ... }
    def add_queue(url, store_name, detail, &callback)
      @@pending_urls << {url: url, store_name: store_name, detail: detail, callback: callback}
    end

    def queue
      @@pending_urls
    end

    def requesting
      @@requesting_url
    end

    def fetch
      #Log.info %Q{PEND: #{@@pending_urls.length}, REQU: #{@@requesting_url.length}, FETCHED: #{@@fetched_urls.length}, FAIL: #{@@failed_url.length}}

      (@@max_parallel_request - @@requesting_url.length).times do
        return if @@pending_urls.length == 0
        visiting = @@pending_urls.shift
        @@requesting_url << visiting[:url]
        Log.info "visiting_url: #{visiting[:url]}"

        if visiting[:detail].nil? || visiting[:detail][:method].eql?("GET")
          if !is_uri_encoded?(visiting[:url])
            http = EM::HttpRequest.new(visiting[:url], :connect_timeout => 50, :inactivity_timeout => 50).get :head => {"User-Agent" => "curl/7.22.0 (i686-pc-linux-gnu) libcurl/7.22.0 OpenSSL/1.0.1 zlib/1.2.3.4 libidn/1.23 librtmp/2.3"}
          else
            http = EM::HttpRequest.new(URI.encode(visiting[:url]), :connect_timeout => 50, :inactivity_timeout => 50).get :head => {"User-Agent" => "curl/7.22.0 (i686-pc-linux-gnu) libcurl/7.22.0 OpenSSL/1.0.1 zlib/1.2.3.4 libidn/1.23 librtmp/2.3"}
          end
        else
          if !is_uri_encoded?(visiting[:url])
            http = EM::HttpRequest.new(visiting[:url], :connect_timeout => 50, :inactivity_timeout => 50).post :body => visiting[:detail]["params"], :head => {"User-Agent" => "curl/7.22.0 (i686-pc-linux-gnu) libcurl/7.22.0 OpenSSL/1.0.1 zlib/1.2.3.4 libidn/1.23 librtmp/2.3"}
          else
            http = EM::HttpRequest.new(URI.encode(visiting[:url]), :connect_timeout => 50, :inactivity_timeout => 50).post :body => visiting[:detail]["params"], :head => {"User-Agent" => "curl/7.22.0 (i686-pc-linux-gnu) libcurl/7.22.0 OpenSSL/1.0.1 zlib/1.2.3.4 libidn/1.23 librtmp/2.3"}
          end
        end

        http.callback {
          http_callback(http, visiting)
        }

        http.errback {
          http_errback(http, visiting[:url])
        }
      end
    end

    def is_uri_encoded?(url)
      SITES.each do |site_name|
        if url.include?(site_name)
          return false
        end
      end
      return true
    end

    def http_callback(http, visiting)
      @@requesting_url.delete(visiting[:url])
      @@fetched_urls << visiting[:url]

      if http.response_header.status == 200
        visiting[:callback].call(visiting[:url], http.response)
      elsif http.response_header.status == 302 || http.response_header.status == 301
        res = FashionCrawler::Models::Resource.find_by(url: visiting[:url])
        res.update_attributes(last_access: DateTime.now, is_visited: true)
        redirect_location = http.response_header.location
        unless FashionCrawler::Models::Resource.where(url: redirect_location).exists?
          FashionCrawler::Models::Resource.create({
            url: redirect_location,
            task: res.task,
            is_visited: false,
            detail: res.detail,
            site_name: res.site_name,
            store: res.store
          })
        end
        Log.info "Redirected : url=[#{visiting[:url]}] TO #{redirect_location}: status=[#{http.response_header.status}]"
      elsif http.response_header.status == 404
        res = FashionCrawler::Models::Resource.find_by(url: visiting[:url])
        res.update_attributes(last_access: DateTime.now, is_visited: true)
      else
        @@failed_url << visiting[:url]
        FashionCrawler::Models::Resource.find_by(url: visiting[:url]).update_attributes(last_access: DateTime.now, is_visited: true)
        Log.error "Failed request : url=[#{visiting[:url]}] : status=[#{http.response_header.status}]"
      end
    end

    def http_errback(http, url)
      FashionCrawler::Models::Resource.find_by(url: url).update_attributes(last_access: DateTime.now, is_visited: true)
      Log.error "Failed request : url=[#{url}] : error=[#{http.error}]"
      @@requesting_url.delete(url)
      @@failed_url << url
    end

  end
end
