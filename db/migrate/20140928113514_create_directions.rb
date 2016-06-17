class CreateDirections < ActiveRecord::Migration
  def change
    create_table :directions do |t|
      t.string :display_name
      t.string :search_name
      t.references :bus_line, index: true

      t.timestamps
    end
  end
end
