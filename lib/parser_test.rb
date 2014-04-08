module Parser
  require "#{File.expand_path(File.dirname(__FILE__))}/parser.rb"

  def self.run_tests
    puts "HTML strip test #{ html_strip_test ? 'PASS' : 'FAIL'}"
    puts "Extract title test #{ extract_title_test ? 'PASS' : 'FAIL'}"
    puts "Extract content test #{ extract_content_test ? 'PASS' : 'FAIL'}"
    puts "Get filenames test #{ get_filenames_test ? 'PASS' : 'FAIL'}"
  end

  def self.html_strip_test
    dirty = "<html><head></head><body><h1>disco dancer</h1><p>death</p></body></html>"
    Parser.strip_html(dirty) == "disco dancer death"
  end

  def self.extract_title_test
    filename = "19362.txt"
    title = "In the Year 2889"
    book = Parser.parse_book(filename)

    book.title == title
  end

  def self.extract_content_test
    filename = "19362.txt"
    first_line = "Project Gutenberg's In the Year 2889, by Jules Verne and Michel Verne"
    book = Parser.parse_book(filename)

    book.content.split(/\n/, 2).first.chomp == first_line
  end

  def self.get_filenames_test
    Parser.get_filenames.size == 349
  end

  run_tests

end
