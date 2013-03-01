class CreateOfferingsUsersTable < ActiveRecord::Migration
  def self.up
    create_table :offerings_users, :id => false do |t|
        t.references :offering
        t.references :user
    end
    add_index :offerings_users, [:offering_id, :user_id]
    add_index :offerings_users, [:user_id, :offering_id]
  end

  def self.down
    drop_table :offerings_users
  end
end
