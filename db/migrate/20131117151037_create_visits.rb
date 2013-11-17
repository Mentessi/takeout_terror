class CreateVisits < ActiveRecord::Migration
  def change
    create_table :visits do |t|
      t.integer :user_id
      t.integer :establishment_id
      t.integer :fs_rating_value
      
      t.timestamps
    end
  end
end
