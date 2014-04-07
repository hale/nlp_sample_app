require 'sanitize'

ROOT = File.expand_path(File.dirname(__FILE__))
SCI_FI_DIR = ROOT + "/assets/gutenberg_sci_fi"

Book = Struct.new(:content, :title)

def get_books
  books = []
  get_filenames.each do |filename|
    print "Adding #{filename}..."
    begin
      books << parse_book(filename)
      puts "SUCCESS"
    rescue ArgumentError
      puts "ERROR"
    end
  end
  books
end

def strip_html(str)
  Sanitize.clean(str).squeeze(" ").strip
end

def parse_book(filename)
  content = IO.read("#{SCI_FI_DIR}/#{filename}")
  content = strip_html(content) if filename.split(/\./)[1] == 'html'

  title = nil
  content.split(/\n/).each do |line|
    title ||= line[7..-1].chomp if line[0..6] == "Title: "
  end
  Book.new(content, title)
end

def get_filenames
  [].tap do |list|
    Dir.new(SCI_FI_DIR).each do |filename|
      list << filename
    end
  end - [".", ".."]
end
