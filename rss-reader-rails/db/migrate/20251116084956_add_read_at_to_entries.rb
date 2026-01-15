class AddReadAtToEntries < ActiveRecord::Migration[8.1]
  def change
    add_column :entries, :read_at, :datetime
  end
end
