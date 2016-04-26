class Direction < ActiveRecord::Base
  belongs_to :line
  has_many :bus_stops
end
