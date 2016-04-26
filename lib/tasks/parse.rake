# encoding: utf-8
#require 'debugger'
require 'logger'
require 'pdf_parser/fahrplan_processor'
require 'helper/active_record_converter'
require 'helper/active_record_converter'
require 'pdf_parser/pdf_content_extractor'
require 'pdf_parser/sanitiser'
require 'pdf_parser/splitter'

namespace :parse do

	# rake parse:pdf[../pdf_parser/fahrplantabelle/Linie1/sonntag/test.pdf]
	desc "Create a text file from a pdf file"
	task :pdf, [:in] => :environment do |t, args|
		if args.in.nil?
			puts "Usage: rake parse:pdf[<path_to_file>]"
			exit
		end
		src = File.expand_path(File.dirname(__FILE__)) + "/" + args.in
		PdfContentExtractor.go(src)
	end

	# rake parse:split[../pdf_parser/fahrplantabelle/Linie1/sonntag/test.txt]
	desc "Split line with both directions into two files"
	task :split, [:file] => :environment do |t, args|		
		if args.file.nil?
			puts "Usage: rake parse:split[<path_to_file>]"
			exit
		end
		file = File.expand_path(File.dirname(__FILE__)) + "/" + args.file
		Splitter.split(file)
	end

	# rake parse:sanitise[../pdf_parser/fahrplantabelle/Linie1/sonntag/test.txt]
	desc "Remove rubbish"
	task :sanitise, [:file] => :environment do |t, args|
		if args.file.nil?
			puts "Usage: rake parse:sanitise[<path_to_file>]"
			exit
		end
		file = File.expand_path(File.dirname(__FILE__)) + "/" + args.file
		Sanitiser.clean_up(file)
	end

	# Parses a text file containing departure information like the one you can find here:
	# http://www.rvv.de/linie-6-fahrplantabelle-mf-ab-16.09.2014
	# rake parse:bus_line[../pdf_parser/fahrplantabelle/Linie1/sonntag/test_clean.txt]
	desc "Create bus line by parsing a text file"
	task :bus_line, [:file_name, :processor_name] => :environment do |t, args|

		if args.file_name.nil?
			puts "Usage: rake parse:bus_line[<file>,<processor_name>]"
			exit
		end		
		LOG.debug "args.file_name = %s" % args.file_name
		LOG.debug "args.processor_name = %s" % args.processor_name

		src_file = File.expand_path(File.dirname(__FILE__)) + "/" + args.file_name
		fp = FahrplanProcessor.new(src_file)
		result = fp.process(args.processor_name)

		ActiveRecordConverter.convert_and_persist(result)
	end

#=============================
# Old stuff, should be delted?
#=============================

	desc "Create bus stops by reading file <file_name>, assigning to direction with id <integer>, change order <reverse>"
	task :bus_stops, [:file_name, :direction_id, :reverse] => :environment do |t, args|
		puts "Params: #{args[:file_name]}, #{args[:direction_id]}, #{args[:reverse]}"
		d = Direction.find(args[:direction_id])
		puts "Assigning bus stops to line #{d.line.name}, direction #{d.name}"
		f = File.open(args[:file_name], 'r:UTF-8')
		bus_stops = Array.new
		f.each_line do |line|
			bs = BusStop.new
			bs.name = line.chomp()
			bus_stops << bs
		end
		if args[:reverse] != nil && args[:reverse] == 'reverse'
			bus_stops.reverse!
		end
		bus_stops.collect {|bs| puts "Bus stop: #{bs.name}"}
		d.bus_stops = bus_stops
		f.close
	end

	desc "Create depatures"
	task :departures, [:bus_stop_id, :day_type, :from_h, :to_h, :minute] => :environment do |t, args|
			bsi = args[:bus_stop_id].to_i
			dt = args[:day_type].to_s
			f = args[:from_h].to_i
			t = args[:to_h].to_i
			m = args[:minute].to_i
			bs = BusStop.find(bsi)

			for i in f..t
				departure = nil
				bs.departures.each do |d|
					if d.hour == i && d.day_type == dt && d.bus_stop_id == bsi
						departure = d
						break
					end
				end

				if departure.nil?
					puts "New departure record"
					departure = Departure.new
					departure.hour = i
					departure.minute = "#{m}"
					departure.bus_stop_id = bs.id
					if dt == 'holiday'
			  		departure.holiday!
			  	elsif dt == 'saturday'
						departure.saturday!
			  	else
			  		departure.weekday!
			  	end
				else
					puts "Existing departure record"
					departure.minute = departure.minute + ",#{m}"
				end

				puts "Adding departure for day_type: #{dt}, at #{i}:#{m}"
		  	departure.save
			end
	end

	desc "Create day types"
	task :day_types, [:direction_id] => :environment do |t, args|
		puts "Params: #{args[:direction_id]}}"
		d = Direction.find(args[:direction_id])
		d.bus_stops.each do |bus_stop|
			if bus_stop.day_types.empty?
				dt_week_day = DayType.new
				dt_week_day.name = "Wochentag"
				bus_stop.day_types << dt_week_day

				dt_saturday = DayType.new
				dt_saturday.name = "Samstag"
				bus_stop.day_types << dt_saturday

				dt_holiday = DayType.new
				dt_holiday.name = "Feiertag"
				bus_stop.day_types << dt_holiday
			end
			dts = bus_stop.day_types.collect {|dt| dt.name}.join(", ")
			puts "Bus stop #{bus_stop.name} has these day types: #{dts}"
		end
	end

	desc "Create departure hours"
	task :departure_hours, [:bus_stop_id, :day_type, :from, :to] => :environment do |t, args|
		puts "Params: #{args[:bus_stop_id]}, #{args[:day_type]}, #{args[:from]}, #{args[:to]}"
		bs = BusStop.find(args[:bus_stop_id])
		puts "Found bus stop: #{bs.name}"
		used_day_type = nil
		bs.day_types.each do |dt|
			if dt.name == args[:day_type]
				used_day_type = dt
				puts "Using day type: #{used_day_type.name}"
			end
		end
		if used_day_type != nil
			s = args[:from]
			e = args[:to]
			for i in s..e
				puts "Adding departure hour: #{i}"
		  	dh = DepatureHour.new
		  	dh.h = i
		  	dh.day_type_id = used_day_type.id
		  	dh.save
			end
		end
	end

	desc "Create depature minutes"
	task :depature_minutes, [:bus_stop_id, :day_type, :from, :to, :m] => :environment do |t, args|
		puts "Params: #{args[:bus_stop_id]}, #{args[:day_type]}, #{args[:from]}, #{args[:to]}, #{args[:m]}"
		bs = BusStop.find(args[:bus_stop_id])
		puts "Found bus stop: #{bs.name}"
		used_day_type = nil
		bs.day_types.each do |dt|
			if dt.name == args[:day_type]
				used_day_type = dt
				puts "Set day type to: #{used_day_type.name}"
			end
		end
		s = args[:from].to_i
		e = args[:to].to_i
		for i in s..e
			debugger
			used_day_type.depature_hours.each do |dh|
				if dh.h == i
					puts "Adding depature minute: #{args[:m]} to depature hour #{dh.h}"
					dm = DepatureMinute.new
					dm.m = args[:m]
					dh.depature_minutes << dm
					break
				end
			end
		end
	end

	desc "Parsen von Linie 2AB"
	task :line2AB, [:file_name, :persist] => :environment do |t, args|
		# puts "Load path: #{$:}"
		# puts "Program file# {__FILE__}"
		puts "Params: #{args[:file_name]}, #{args[:persist]}"
		file_content = Array.new
		file_content = read_raw_pdf(args[:file_name])
		puts "Starting with #{file_content.size()} lines to parse\n\r"

		clear_garbage(file_content)
		puts "#{file_content.size()} lines left to parse...\n\r"

		extract_bus_line(file_content)
		puts "#{file_content.size()} lines left to parse...\n\r"

		extract_day_type(file_content)
		puts "#{file_content.size()} lines left to parse...\n\r"

		extract_depature_hours(file_content)
		puts "#{file_content.size()} lines left to parse...\n\r"

		extract_bus_stops(file_content)
		puts "#{file_content.size()} lines left to parse...\n\r"
	end

end