class Song < ActiveRecord::Base

  def self.search_keywords(keywords)
    query = Song.where("name like :kw OR category like :kw OR singer like :kw OR author like :kw OR album like :kw", :kw=>"%#{keywords}%").to_sql + "LIMIT 100"
    songs = Song.find_by_sql(query)
  end
end
