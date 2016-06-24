class BusLine < ActiveRecord::Base
	has_many :directions

  scope :active, -> { where("active = ?", 1) }
end
