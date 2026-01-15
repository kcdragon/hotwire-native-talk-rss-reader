class AddOauthFieldsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :oauth_provider, :integer
    add_column :users, :oauth_uid, :string

    add_index :users, [ :oauth_provider, :oauth_uid ], unique: true, where: "oauth_provider IS NOT NULL AND oauth_uid IS NOT NULL"
  end
end
