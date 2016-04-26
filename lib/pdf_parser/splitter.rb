# If one line consists of both direction information
# this information gets splitt into two diffrent files 
class Splitter

	@@DAY_TYPE_SUNDAY = "Sonn-/Feiertag"
	@@DAY_TYPE_SATURDAY = "Samstag"
	@@DAY_TYPE_WORKDAY = "Montag - Freitag"

	def self.split(file)
		# Result is written to this file
		forward = file.match(/^(.*)\.txt/)[1] + "_forward.txt"
		backward = file.match(/^(.*)\.txt/)[1] + "_backward.txt"

		begin
		  forward_file = File.open(forward, "w")
		  backward_file = File.open(backward, "w")

			File.open(file, "r") do |f|
			  f.each_line do |line|
			  	if m = line.strip.match(/^(\D+)([\d\s]+)(\D+)([\d\s]+)$/)
					  forward_file.write("#{m[1]}#{m[2]}\n")
					  backward_file.write("#{m[3]}#{m[4]}\n")
			  	elsif m = Splitter.isLineWithContentDayTypeDeparureHour(line)
					  forward_file.write("#{m[1]}\n")
					  backward_file.write("#{m[2]}\n")
			  	else
  					forward_file.write("#{line}")
					  backward_file.write("#{line}")
			  	end
			  end
			end

		rescue IOError => e
		  #some error occur, dir not writable etc.
		  LOG.error "Could not write to file bacause #{e}"
		ensure
		  forward_file.close unless forward_file.nil?
		  backward_file.close unless backward_file.nil?
		end
	end

	def self.isLineWithContentDayTypeDeparureHour(line)
		m = line.match(/(Sonn-\/Feiertag.*)(Sonn-\/Feiertag.*)/)
		if m != nil && m.size == 3
			return m
		end

		m = line.match(/(Samstag.*)(Samstag.*)/)
	  if m != nil && m.size == 3
			return m
		end

		m = line.match(/(Montag - Freitag.*)(Montag - Freitag.*)/)
	  if m != nil && m.size == 3
			return m
		end

		return nil
	end
end