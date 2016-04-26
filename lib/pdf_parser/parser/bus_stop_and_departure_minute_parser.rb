class BusStopAndDepartureMinuteParser

  # Extract departure minutes
  def parse(line, bus_line_transformator)

    LOG.debug "Extracting departure minutes..."

    if match = line.match(/^(\D+)([\d\s]+)$/)
      # One line contains one direction

      name = match[1].strip

      bst = bus_line_transformator.get_bus_stop(name)

      if bst.nil?
        bst = BusStopTransformator.new
        bst.name = name
      end

      last_m = 60
      h = -1
      dep_h = bus_line_transformator.dep_h.clone()
      dep_minutes = match[2].split()
      dep_minutes.each do |m|
        # Update departure hour
        if m.to_i <= last_m
          h = dep_h.shift
          bst.dep_hm[h] = Array.new
        end
        LOG.debug("%s leaving %s:%s" % [bst.name, h, m])
        bst.dep_hm[h] << m.to_i
        last_m = m.to_i
      end

      bus_line_transformator.bus_stops << bst

    else
      LOG.error "Could not extract departure minutes:\n#{line}"
    end

    return bst
  end
end