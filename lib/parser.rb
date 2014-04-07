require 'sanitize'

ROOT = File.expand_path(File.dirname(__FILE__))
SCI_FI_DIR = ROOT + "/assets/gutenberg_sci_fi"

Book = Struct.new(:content, :title)

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

def run_tests
  puts "HTML strip test #{html_strip_test ? 'PASS' : 'FAIL'}"
  puts "Extract title test #{ extract_title_test ? 'PASS' : 'FAIL'}"
  puts "Extract content test #{ extract_content_test ? 'PASS' : 'FAIL'}"
  puts "Get filenames test #{ get_filenames_test ? 'PASS' : 'FAIL'}"
end

def html_strip_test
  dirty = "<html><head></head><body><h1>disco dancer</h1><p>death</p></body></html>"
  strip_html(dirty) == "disco dancer death"
end

def extract_title_test
  filename = "19362.txt"
  title = "In the Year 2889"
  book = parse_book(filename)

  book.title == title
end

def extract_content_test
  filename = "19362.txt"
  first_line = "Project Gutenberg's In the Year 2889, by Jules Verne and Michel Verne"
  book = parse_book(filename)

  book.content.split(/\n/, 2).first.chomp == first_line
end

def get_filenames_test
  get_filenames.size == 349
end

run_tests

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
