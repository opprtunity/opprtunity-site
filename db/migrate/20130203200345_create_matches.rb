class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.references :user
      t.integer :target_id
      t.integer :score

      t.timestamps
    end
    add_index :matches, :user_id
  end
end
