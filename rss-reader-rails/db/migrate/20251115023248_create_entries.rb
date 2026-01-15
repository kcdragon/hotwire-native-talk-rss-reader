class CreateEntries < ActiveRecord::Migration[8.1]
  def change
    create_table :entries do |t|
      t.references :feed, null: false, foreign_key: true
      t.string :title
      t.string :url
      t.datetime :published_at

      t.timestamps
    end
  end
end
