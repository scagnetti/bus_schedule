class BusStopTransformator
	attr_accessor :name, :dep_hm

	def initialize()
		@name = ""
		@dep_hm = Hash.new
	end

	def resolve_intervals()
		resolved_dep_hm = Hash.new
		@dep_hm.each do |key, value|
			if key.match(/^(\d{1,2})-(\d{1,2})$/)
				from = $1.to_i
				to = $2.to_i
				interval = (from..to).to_a
				interval.each{|v|
					resolved_dep_hm[v] = value
				}
			else
				resolved_dep_hm[key] = value
			end
		end
		return resolved_dep_hm
	end

	def to_s
		s = "Bus stop: %s\n" % @name
		r = resolve_intervals()
		r.each do |key, value|
			value.each do |e|
				s << "%02d:%02d\n" % [key, e]
			end
			#s = s + "\n"
		end
		return s
	end
end