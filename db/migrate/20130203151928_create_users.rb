class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|

      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :zip_code
      t.string :company_name
      t.string :google_plus
      t.string :skype
      t.string :phone
      t.text :about
      t.string :linked_in
      t.string :company_url
      t.integer :parent_id
      t.boolean :registered, default: false
      t.string :ip

      t.string :uid
      t.string :provider
      t.string :token
      t.string :secret

      t.float :latitude
      t.float :longitude

      t.timestamps
    end
    add_index :users, [:uid]
  end
end
