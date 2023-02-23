class CreateFlightAirports < ActiveRecord::Migration[7.0]
  def change
    create_table :flight_airports do |t|
      t.boolean :is_departure
      t.references :flight, null: false, foreign_key: true
      t.references :airport, null: false, foreign_key: true

      t.timestamps
    end
  end
end
