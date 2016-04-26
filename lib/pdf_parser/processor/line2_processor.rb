class Line2Processor

  def initialize(bus_line_transformator)
    @bus_line_transformator = bus_line_transformator
  end

  def process_header(f)

    items = File.basename(f.path).split(">")
    @bus_line_transformator.first_stop = items[0].strip
    puts @bus_line_transformator.first_stop
    
    @bus_line_transformator.last_stop = items[1].strip.sub(".txt", "")
    puts @bus_line_transformator.last_stop
    @bus_line_transformator.name = "Linie2AB"

  end

end