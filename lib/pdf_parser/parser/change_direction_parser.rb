require 'helper/active_record_converter'

class ChangeDirectionParser

  def parse(line, bus_line_transformator)
    # Write schedule to database
    ActiveRecordConverter.convert_and_persist(bus_line_transformator)

    # Make necessary changes
    bus_line_transformator.change_direction
    bus_line_transformator.bus_stops.clear
    dep_h = Array.new
  end



end