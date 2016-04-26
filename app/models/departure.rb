class Departure < ActiveRecord::Base
  belongs_to :bus_stop
  enum day_type: [ :weekday, :saturday, :holiday ]
end
