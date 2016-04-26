class DefaultProcessor

  def initialize(bus_line_transformator)
    @bus_line_transformator = bus_line_transformator
  end

  def process_header(f)
    # We expect the first line to hold the first part of the direction
    # information of the bus line ($. == 1)
    if m = f.readline.match(/^(.*?) -/)
      LOG.info "First part of bus line direction: %s" % m[1]
      @bus_line_transformator.first_stop = m[1]
    else
      raise "Could not extract first part of bus line direction"
    end

    # We expect the second line to hold the name of the line and
    # the second part of the direction information of the bus line ($. == 2)
    if m = f.readline.match(/^Linie\s+(\d{1,2}).* - (.*)/)
      LOG.info "Bus line name: %s" % m[1]
      @bus_line_transformator.name << "Linie #{m[1]}"
      LOG.info "Second part of bus line direction: %s" % m[2]
      @bus_line_transformator.last_stop = m[2]
    else
      raise "Could not extract name of bus line or the scond part of bus line direction"
    end
  end

end