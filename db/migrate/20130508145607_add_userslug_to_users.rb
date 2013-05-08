class AddUserslugToUsers < ActiveRecord::Migration
  def change
    add_column :users, :user_slug, :string, :unique => true
  end
end
