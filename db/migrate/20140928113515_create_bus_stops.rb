class CreateBusStops < ActiveRecord::Migration
  def change
    create_table :bus_stops do |t|
      t.string :display_name
      t.string :search_name
      t.references :direction, index: true

      t.timestamps
    end
  end
end
