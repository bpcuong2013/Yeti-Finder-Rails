class CreateFinds < ActiveRecord::Migration
  def change
    create_table :finds do |t|
      t.integer :user_id
      t.integer :yeti_id

      t.timestamps
    end
  end
end
