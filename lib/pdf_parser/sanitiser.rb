# Removes garbage from parsed schedules
class Sanitiser

	def self.clean_up(file)
		# Result is written to this file
		clean_file = file.match(/^(.*)\.txt/)[1] + "_clean.txt"

		File.open(clean_file, 'w') do |cf| 
			File.open(file, "r") do |f|
			  f.each_line do |line|
			  	if line.lstrip().size() == 0
			  		#puts "Removing empty line..."

			  	elsif line.lstrip().start_with?("gültig ab")
			  		puts "Removing #{line.lstrip()}"

			  	elsif line.lstrip().start_with?("VERKEHRSHINWEIS")
			  		puts "Removing #{line.lstrip()}"

			  	elsif line.lstrip().match(/^\s*\d\w/)
			  		# Remove special line names like 6S
			  		puts "I think this line holds a special line name we don't need."
			  		puts "Removing #{line.lstrip()}"

			  	elsif line.lstrip().match(/^HBF\/Albertstraße\s+an/)
			  		puts "Removing #{line.lstrip()}"

			  	elsif line.lstrip().start_with?("ZEICHENERKLÄRUNG")
			  		puts "Removing #{line.lstrip()}"

			  	elsif line.lstrip().start_with?("Seite:")
			  		puts "Removing #{line.lstrip()}"

			  	elsif line.lstrip().match(/^\s*0\s*$/)
			  		puts "Removing line with content '0'"

			  	else
			  		cf.write(line.lstrip())
			  	end
			  end
			end
		end
	end

end