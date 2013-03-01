class CreateNeedsUsersTable < ActiveRecord::Migration
  def self.up
    create_table :needs_users, :id => false do |t|
        t.references :need
        t.references :user
    end
    add_index :needs_users, [:need_id, :user_id]
    add_index :needs_users, [:user_id, :need_id]
  end

  def self.down
    drop_table :needs_users
  end
end
