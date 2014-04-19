require 'spec_helper'

describe Parser do
  it "extracts the title" do
    filename = "19362.txt"
    title = "In the Year 2889"
    book = Parser.parse_book(filename)

    expect(book.title).to eq(title)
  end

  it "extracts the content" do
    filename = "19362.txt"
    first_line = "Project Gutenberg's In the Year 2889, by Jules Verne and Michel Verne"
    book = Parser.parse_book(filename)

    expect(book.content.split(/\r/, 2).first.chomp).to eq(first_line)
  end

  it "gets the right filenames" do
    expect(Parser.get_filenames.size).to eq(151)
  end
end
