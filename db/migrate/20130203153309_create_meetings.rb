class CreateMeetings < ActiveRecord::Migration
  def change
    create_table :meetings do |t|
      t.integer :rating
      t.datetime :date
      t.string :medium
      t.references :user

      t.timestamps
    end
  end
end
