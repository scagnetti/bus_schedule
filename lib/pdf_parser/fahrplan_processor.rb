# encoding: utf-8
require 'logger'
require 'helper/bus_stop_transformator'
require 'helper/bus_line_transformator'
require 'pdf_parser/analyser/text_line_analyser'
require 'pdf_parser/processor/default_processor'
require 'pdf_parser/processor/line2_processor'

# Processes a text file containing departure information for a certain bus line
class FahrplanProcessor
  attr_writer :text_line_analyser, :parser

  def initialize(input_file)
    LOG.debug "Initializing FahrplanProcessor..."
    @input_file = input_file
    # The data holder during processing
    @bus_line_transformator = BusLineTransformator.new
    @analyser = TextLineAnalyser.new
    @processor_map = {'default' => DefaultProcessor.new(@bus_line_transformator),
      'Linie2' => Line2Processor.new(@bus_line_transformator)}
  end

  def process(processor_name)
    LOG.info "Processing file %s with processor" % @input_file
    
    if @processor_map.has_key?(processor_name)
      p = @processor_map[processor_name]
      LOG.info "Using processor %s" % processor_name
    else
      p = @processor_map['default']
      LOG.info "Using default processor"
    end

    f = File.open(@input_file, "r:UTF-8")

    p.process_header(f)

    f.each do |line|
      parser = @analyser.analyse(line)
      parser.parse(line, @bus_line_transformator)
    end

    f.close

    @analyser.get_garbage_collector().dump_to_file()

    return @bus_line_transformator
  end

end