require 'optparse'
require 'ostruct'
require 'pp'

class SimpleOptionParser

  def self.parse(args)
    options = OpenStruct.new
    options.page = -1
    op = OptionParser.new do |opts|
      opts.banner = "Usage: pdfContentExtractor.rb [options] <src_file> <dest_file>"
      opts.on("-p", "--page P", OptionParser::DecimalInteger, "Extract only the content of the given page number") do |p|
        options.page = p
      end
      opts.on_tail("-h", "--help", "Show this message") do
        puts opts
        exit
      end
    end
    op.parse!(args)
    options
  end

end