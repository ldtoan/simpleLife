class MusicsController < ApplicationController
  def index
    if params["keywords"].present?
      @songs = Song.search_keywords(params["keywords"])
    else
      @songs = Song.limit(1)
    end
  end
end
