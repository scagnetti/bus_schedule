require 'rubygems'
require 'pdf/reader'
require 'helper/simple_option_parser'

# Extracts text content from a PDF file
class PdfContentExtractor
  
  def self.write_to(content, file)
    puts "============"
    puts "Text content"
    puts "============"
    puts content
    puts "Writing content to " + file
    File.open(file, 'w') {|f| f.write(content) }
  end

  def self.go(src_file)

    options = SimpleOptionParser.parse(ARGV)

    puts "Reading file #{src_file}"

    text_file = src_file.match(/^(.*)\.pdf/)[1] + ".txt"

    PDF::Reader.open(src_file) do |reader|
      puts "PDF version: #{reader.pdf_version}"
      #puts "Info: #{reader.info}"
      #puts "Metadata: #{reader.metadata}"
      #puts reader.objects.inspect
      puts "Pages: #{reader.page_count}"
      puts reader.objects.inspect
      
      if options.page == -1
        # Read everything
        content = ""
        reader.pages.each do |page|
          content << page.text
        end
        self.write_to(content, text_file)
      else
        # Read one page
        self.write_to(reader.page(options.page).text, text_file)
      end

      # reader.methods.each do |m|
      #   puts "Method: #{m}"
      # end
      
      #reader.instance_variables.each do |v|
      #  puts "Instance variable: #{v}"
      #end
    end
  end

end