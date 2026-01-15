class AddSummaryToEntries < ActiveRecord::Migration[8.1]
  def change
    add_column :entries, :summary, :text
  end
end
