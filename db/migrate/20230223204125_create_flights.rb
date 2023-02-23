class CreateFlights < ActiveRecord::Migration[7.0]
  def change
    create_table :flights do |t|
      t.string :flight_number
      t.integer :price
      t.date :departure_date
      t.date :arrival_date
      t.time :departure_time
      t.time :arrival_time
      t.references :airline, null: false, foreign_key: true

      t.timestamps
    end
  end
end
