class ActiveRecordConverter

  #=========================
  # Create database entities
  #=========================
  def self.convert_and_persist(bus_line_transformator)
    l = Line.where("name LIKE ?", bus_line_transformator.name).first
    if l.nil?
      LOG.debug "Creating new bus line #{bus_line_transformator.name}"
      l = Line.new
      l.name = bus_line_transformator.name
      l.save!
    else
      LOG.debug "Updating existing bus line #{l.name}"
    end

    d = Direction.where("line_id = ? AND name LIKE ?", l.id, bus_line_transformator.direction).first
    if d.nil?
      LOG.debug "Creating new bus direction #{bus_line_transformator.direction}"
      d = Direction.new
      d.name = bus_line_transformator.direction
      d.line_id = l.id
      d.save!
    else
      LOG.debug "Updating existing bus direction #{d.name}"
    end

    bus_line_transformator.bus_stops.each do |bst|
      s = BusStop.where("direction_id = ? AND name LIKE ?", d.id, bst.name).first
      if s.nil?
        LOG.debug "Creating new bus stop #{bst.name}"
        s = BusStop.new
        s.name = bst.name
        s.direction_id = d.id
        s.save!
      else
        LOG.debug "Updating existing bus stop #{s.name}"
      end

      LOG.debug "Creating new bus departure timetable"
      bst.resolve_intervals().each do |key,value|
        dep = Departure.new
        dep.day_type = bus_line_transformator.day_type
        dep.hour = key
        dep.minute = value.join(',')
        dep.bus_stop_id = s.id
        dep.save!
      end
    end
  end

end