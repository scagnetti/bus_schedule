class DayTypeAndDepartureHourParser
  DAY_TYPE_WEEKDAY = /Montag - Freitag\s*/
  DAY_TYPE_SATURDAY = /Samstag\s*/
  DAY_TYPE_HOLIDAY = /Sonn-\/Feiertag\s*/

  # Extract depature hours
  def parse(line, bus_line_transformator)
    LOG.debug "Extracting departure hours..."
    line.strip!
    
    if line.match(DAY_TYPE_WEEKDAY)
      line.sub!(DAY_TYPE_WEEKDAY, "")
      bus_line_transformator.day_type = "weekday"
      LOG.debug "Setting day type to: weekday"

    elsif line.match(DAY_TYPE_HOLIDAY)
      line.sub!(DAY_TYPE_HOLIDAY, "")
      bus_line_transformator.day_type = "holiday"
      LOG.debug "Setting day type to: holiday"

    elsif line.match(DAY_TYPE_SATURDAY)
      line.sub!(DAY_TYPE_SATURDAY, "")
      bus_line_transformator.day_type = "saturday"
      LOG.debug "Setting day type to: saturday"
    end

    line.split().each do |e|
      bus_line_transformator.dep_h << e
      end
      LOG.debug "Departure hours: %s" % bus_line_transformator.dep_h.join(" | ")
  end
end