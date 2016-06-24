class AddActiveToBusLines < ActiveRecord::Migration
  def change
    add_column :bus_lines, :active, :boolean, default: true
  end
end
