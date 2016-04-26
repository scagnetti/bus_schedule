class GarbageCollector

  def initialize()
    @failed_lines_file = File.expand_path(File.dirname(__FILE__)) + "/failed_lines.txt"
    LOG.info "Garbage goes to file: #{@failed_lines_file}"
    @garbage_container = []
  end

  def parse(line, bus_line_transformator)
    @garbage_container << line
  end

  def dump_to_file
    File.open(@failed_lines_file, "w") do |f|
      f.puts(@garbage_container)
    end
  end

end