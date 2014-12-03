class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.string :name
      t.text :link
      t.text :src
      t.string :category
      t.string :singer
      t.string :author
      t.string :album
      t.string :site_name
      t.text :lyric
      t.string :updated

      t.timestamps
    end
  end
end
