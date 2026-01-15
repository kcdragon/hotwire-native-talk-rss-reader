class AddLikedAtToEntries < ActiveRecord::Migration[8.1]
  def change
    add_column :entries, :liked_at, :datetime
  end
end
