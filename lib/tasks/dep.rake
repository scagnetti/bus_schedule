# encoding: utf-8
require 'capybara/poltergeist'

namespace :dep do


desc "Get departure times"
task :get, [:direction, :bus_stop] => :environment do |t, args|
    puts "Starting query on bayern-fahrplan.de with:"
    puts "Direction: #{args.direction}"
    puts "Bus Stop: #{args.bus_stop}"
    # ========Set up begin====================================
    options = {js_errors: false}
    Capybara.register_driver :poltergeist do |app|
      Capybara::Poltergeist::Driver.new(app, options)
    end
    Capybara.default_driver = :poltergeist
    Capybara.javascript_driver = :poltergeist

    internet = Capybara.current_session
    internet.class # => Capybara::Session
    # =========================================================

    # ============Page specific data=========================
    url  = "http://www.bayern-fahrplan.de/de/abfahrt-ankunft"
    # ========================================================

    internet.visit(url)
    # Query departures for the given bus stop
    internet.click_link('Haltestelle')
    internet.fill_in('name_dm', with: args.bus_stop)
    
    internet.click_button("search")

    # Show only departures with the right direction
    internet.click_link('Anzeige-Filter')
    # Deselect everything
    internet.find(:xpath, '//a[@class = "checknone"]').click
    # Select transportation type 'Regionalbus'
    internet.find(:xpath, '//label[text() = "Regionalbus"]').click
    # Select the right direction
    xpath = "//label[text() = '%s']" % args.direction
    id = internet.find(:xpath, xpath)['for']
    xpath = "//label[@for='%s']" % id
    internet.first(:xpath, xpath).click
    
    # Apply filter
    internet.click_button('save1')

    # The browser needs some time to apply the filter
    sleep(1)
    
    xpath_value = "//table[@class='trip']/tbody/tr/td[1]"

    found_departures = []
    internet.all(:xpath, xpath_value).each { |td|
      puts "Candidate for departure: #{td.text}"
      if match = td.text.match(/^(\d{2,2}):(\d{2,2}).*$/)
        puts "Accepted candidate: #{td.text}"
        d = Departure.new
        d.bus_stop_id = @bus_stop.id
        d.hour = match[1].strip.to_i
        d.minute = match[2].strip.to_i
        found_departures << d
      end
    }
    puts "Anzahl gefundener Abfahrtszeiten: #{found_departures.size()}"
    return found_departures;
  end
end