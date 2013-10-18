class CreateYetis < ActiveRecord::Migration
  def change
    create_table :yetis do |t|
      t.integer :city_id
      t.string :lat
      t.string :long
      t.string :name
      t.string :description
      t.boolean :is_anonymous, :default => true

      t.timestamps
    end
  end
end
