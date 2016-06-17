class Direction < ActiveRecord::Base
  belongs_to :bus_line
  has_many :bus_stops
end
