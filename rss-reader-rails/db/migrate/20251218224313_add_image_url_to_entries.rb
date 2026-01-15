class AddImageUrlToEntries < ActiveRecord::Migration[8.1]
  def change
    add_column :entries, :image_url, :string
  end
end
