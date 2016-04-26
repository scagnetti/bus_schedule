require 'pdf_parser/processor/garbage_collector'
require 'pdf_parser/parser/day_type_and_departure_hour_parser'
require 'pdf_parser/parser/bus_stop_and_departure_minute_parser'
require 'pdf_parser/parser/change_direction_parser'

# Looks at a line of text and decides which is the best parser to handle it
class TextLineAnalyser

  def initialize()
    @parser_collection = {gc: GarbageCollector.new, dt_dh: DayTypeAndDepartureHourParser.new,
      bs_dm: BusStopAndDepartureMinuteParser.new, change_dir: ChangeDirectionParser.new}
  end

  def analyse(text)

    if text.lstrip().start_with?("Montag - Freitag") || text.lstrip().start_with?("Sonn-/Feiertag") || text.lstrip().start_with?("Samstag")
      LOG.debug "Choosing DayTypeAndDepartureHourParser"
      return @parser_collection[:dt_dh]

    elsif text.strip().match(/^[A-ZÄÖÜ][A-ZÄÖÜa-zäöüß\/\- ]+.*\d{2}$/)
      # Each line contains the departure information for a whole day
      LOG.debug "Choosing BusStopAndDepartureMinuteParser"
      return @parser_collection[:bs_dm]

    elsif text.lstrip().match(/^.*\s-$/)
      # Line ends with a dash, this is the marker for a direction change
      LOG.debug "Choosing ChangeDirectionParser"
      return @parser_collection[:change_dir]

    else
      LOG.debug "Choosing GarbageCollector"
      LOG.debug text
      return @parser_collection[:gc]
    end

  end

  def get_garbage_collector
    return @parser_collection[:gc]
  end

end