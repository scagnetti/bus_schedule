class BusStop < ActiveRecord::Base
  belongs_to :direction
  has_many :departures
end
