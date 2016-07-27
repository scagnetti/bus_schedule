# encoding: utf-8
require 'net/http'

namespace :bs do

  desc "Check extraction logic for all bus_stops"
  task :check_all => :environment do |t, args|

    http = Net::HTTP.new('busabfahrt.v22016063629535037.supersrv.de',80)

    counter = 0

    #BusStop.where("id < ?", 5).each do |bs|
    BusStop.all.each do |bs|
      response = http.request_head("/bus_stops/%s" % bs.id)
      if response.code != "200"
        counter = counter + 1
        puts "bus_stop #{bs.search_name}, with direction #{bs.direction.search_name} failed. Http status code: #{response.code}" 
      end
    end
    
    puts "#{counter} checks failed"
  end

  # rake bs:from_file
  desc "Create new bus stop from the information given in bs_input.txt"
  task :from_file, [:l, :d] => :environment do |t, args|

    if args.l.nil?
      puts "Missing bus line"
      exit
    else
      puts "Using bus line: #{args.l}"
      res = BusLine.where("name like ?", args.l )
      if res.blank?
        puts "Could not find bus line with name: #{args.l}"
        exit
      else
        bus_line = res.first
      end
    end

    if args.d.nil?
      puts "Missing direction"
      exit
    else
      puts "Using direction: #{args.d}"
      #res = BusLine.where("name like ?", args.l).first.directions.where("display_name like ?", args.d)
      res = bus_line.directions.where("display_name like ?", args.d)
      if res.blank?
        puts "Could not find direction with name: #{args.d}"
        exit
      else
        direction = res.first
      end
    end

    #src = File.expand_path(File.dirname(__FILE__)) + "/" + args.in

    File.readlines('lib/tasks/bs_input.txt').each do |line|
      bs = BusStop.new
      bs.direction_id = direction.id
      bs.display_name = line.strip
      bs.search_name = "Regensburg, #{line.strip}"
      bs.save
    end

    puts "Bus stops created successfully! :)"
  end

end