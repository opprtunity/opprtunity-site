class CreateIndustries < ActiveRecord::Migration
  def change
    create_table :industries do |t|
      t.integer :code
      t.string :groups, array: true
      t.string :description
    end
    add_index :industries, :code
    add_index :industries, :groups
    add_index :industries, :description
  end
end
