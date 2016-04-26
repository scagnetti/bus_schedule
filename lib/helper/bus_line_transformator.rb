class BusLineTransformator
	attr_accessor :name, :first_stop, :last_stop, :bus_stops, :day_type, :dep_h

	def initialize()
		@name = ""
		@first_stop = ""
		@last_stop = ""
		@bus_stops = Array.new
		@day_type = "holiday"
		@dep_h = Array.new
	end

	def change_direction
		tmp = @first_stop
		@first_stop = @last_stop
		@last_stop = tmp 
	end

	def direction
		return "#{@first_stop} > #{@last_stop}"
	end

	def to_s
		s = "String representation of BusLineTransformator\n"
		s << "Bus line: %s\n" % @name
		s << "Direction: %s\n" % @direction
		@bus_stops.each do |bs|
			s << bs.to_s << "\n"
		end
		return s
	end

	def get_bus_stop(name)
		@bus_stops.each do |bst|
			if bst.name == name
				return bst
			end
		end
		return nil
	end
end