require 'capybara/poltergeist'

class BusStopsController < ApplicationController
  before_action :set_bus_stop, only: [:show, :edit, :update, :destroy]
  before_action :user_must_be_logged_in!, except: [:show]

  # GET /bus_stops
  # GET /bus_stops.json
  def index
    @bus_stops = BusStop.all
  end

  # GET /bus_stops/1
  # GET /bus_stops/1.json
  def show
    # Aufberteitung der Abfahrtszeiten für das jquery countdown plugin
    # Format: @departures = ['2015/03/19 22:42:30', '2015/03/19 22:44:00']
    @departures = []
    t = Time.new
    date_part = t.strftime("%Y/%m/%d")
    cur_hour = t.hour
    cur_min = t.min

    # Call method like this:
    # p_direction = "Regensburg Schwabenstraße"
    # p_bust_stop = "Regensburg, Karl-Stieler-Straße"
    @time_only_departures = search(@bus_stop.direction.search_name, @bus_stop.search_name)

    @date_and_time_departures = format_departure_values(@time_only_departures, date_part)
  end

  def format_departure_values(dps, date_part)
    result = Array.new
    dps.each do |d|
      # Add the current date, hours and minutes should alway have two digits
      tmp = sprintf("%s %02d:%02d:00", date_part, d.hour, d.minute)
      logger.info "Formatted deparute time (with date): #{tmp}"
      result << tmp
    end
    return result
  end

  def search(p_direction, p_bus_stop)
    logger.info "Starting query on bayern-fahrplan.de with:"
    logger.info "Direction: #{p_direction}"
    logger.info "Bus Stop: #{p_bus_stop}"
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
    internet.fill_in('name_dm', with: p_bus_stop)
    
    internet.click_button("search")

    # Show only departures with the right direction
    internet.click_link('Anzeige-Filter')
    # Deselect everything
    internet.find(:xpath, '//a[@class = "checknone"]').click
    # Select transportation type 'Regionalbus'
    internet.find(:xpath, '//label[text() = "Stadtbus"]').click
    internet.find(:xpath, '//label[text() = "Regionalbus"]').click
    # Select the right direction
    xpath = "//label[contains(., '%s')]" % p_direction
    id = internet.first(:xpath, xpath)['for']
    xpath = "//label[@for='%s']" % id
    internet.first(:xpath, xpath).click
    
    # Apply filter
    internet.click_button('save1')

    # The browser needs some time to apply the filter
    sleep(1)
    
    xpath_value = "//table[@class='trip']/tbody/tr/td[1]"

    found_departures = []
    internet.all(:xpath, xpath_value).each { |td|
      logger.info "Candidate for departure: #{td.text}"
      if match = td.text.match(/^(\d{2,2}):(\d{2,2}).*$/)
        logger.info "Accepted candidate: #{td.text}"
        d = Departure.new
        d.bus_stop_id = @bus_stop.id
        d.hour = match[1].strip.to_i
        d.minute = match[2].strip.to_i
        found_departures << d
      end
    }
    logger.info "Anzahl gefundener Abfahrtszeiten: #{found_departures.size()}"
    return found_departures;
  end

  # GET /bus_stops/new
  def new
    @bus_stop = BusStop.new
  end

  # GET /bus_stops/1/edit
  def edit
  end

  # POST /bus_stops
  # POST /bus_stops.json
  def create
    @bus_stop = BusStop.new(bus_stop_params)

    respond_to do |format|
      if @bus_stop.save
        format.html { redirect_to @bus_stop, notice: 'Bus stop was successfully created.' }
        format.json { render :show, status: :created, location: @bus_stop }
      else
        format.html { render :new }
        format.json { render json: @bus_stop.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bus_stops/1
  # PATCH/PUT /bus_stops/1.json
  def update
    respond_to do |format|
      if @bus_stop.update(bus_stop_params)
        format.html { redirect_to @bus_stop, notice: 'Bus stop was successfully updated.' }
        format.json { render :show, status: :ok, location: @bus_stop }
      else
        format.html { render :edit }
        format.json { render json: @bus_stop.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bus_stops/1
  # DELETE /bus_stops/1.json
  def destroy
    @bus_stop.destroy
    respond_to do |format|
      format.html { redirect_to bus_stops_url, notice: 'Bus stop was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bus_stop
      @bus_stop = BusStop.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bus_stop_params
      params.require(:bus_stop).permit(:display_name, :search_name, :direction_id)
    end
end
