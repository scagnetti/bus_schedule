class AddLockingColumns < ActiveRecord::Migration
  def change
	add_column :departures, :lock_version, :integer
  end
end
