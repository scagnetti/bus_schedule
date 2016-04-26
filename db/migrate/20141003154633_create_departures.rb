class CreateDepartures < ActiveRecord::Migration
  def change
    create_table :departures do |t|
      t.integer :day_type
      t.integer :hour
      t.integer :minute
      t.references :bus_stop, index: true

      t.timestamps
    end
  end
end
