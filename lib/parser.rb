require 'sanitize'

class Parser
  ROOT = File.expand_path(File.dirname(__FILE__))
  SCI_FI_DIR = ROOT + "/assets/gutenberg_sci_fi"

  Book = Struct.new(:content, :title)

  def self.get_books(reduce_to: 100)
    books = []
    get_filenames.each do |filename|
      print "Adding #{filename}..."
      begin
        books << parse_book(filename, reduce_to: reduce_to)
        puts "SUCCESS"
      rescue ArgumentError
        puts "ERROR"
      end
    end
    books
  end

  def self.parse_book(filename, reduce_to: 100)
    content = IO.read("#{SCI_FI_DIR}/#{filename}")

    title = nil
    remaining_content = ""
    content.split(/\n/).each do |line|
      title ||= line[7..-1].chomp if line[0..6] == "Title: "
      remaining_content << line if rand(100) < reduce_to
    end
    Book.new(remaining_content, title)
  end

  def self.get_filenames
    [].tap do |list|
      Dir.new(SCI_FI_DIR).each do |filename|
        list << filename
      end
    end - [".", "..", ".DS_Store"]
  end
end
