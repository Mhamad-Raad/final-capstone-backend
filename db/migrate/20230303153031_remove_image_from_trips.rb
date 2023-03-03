class RemoveImageFromTrips < ActiveRecord::Migration[7.0]
  def change
    remove_column :trips, :image, :string
  end
end
