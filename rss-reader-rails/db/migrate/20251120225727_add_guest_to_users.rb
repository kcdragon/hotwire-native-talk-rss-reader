class AddGuestToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :guest, :boolean, default: false, null: false

    change_column_null :users, :email_address, true
    change_column_null :users, :password_digest, true

    remove_index :users, :email_address
    add_index :users, :email_address, unique: true, where: "email_address IS NOT NULL"
  end
end
