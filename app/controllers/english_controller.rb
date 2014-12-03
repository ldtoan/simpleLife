class EnglishController < ApplicationController
  def index
    @lessons = []
    for i in 1..304 do
      @lessons << "http://lopngoaingu.com/Dynamic_English_Study/audio/#{i}.mp3"
    end
  end
end
