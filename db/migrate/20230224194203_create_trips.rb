class CreateTrips < ActiveRecord::Migration[7.0]
  def change
    create_table :trips do |t|
      t.integer :price
      t.integer :rating
      t.string :destination_city
      t.string :description
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
