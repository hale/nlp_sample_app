require 'spec_helper'

describe Searcher do
  it "matches against book titles" do
    book = FactoryGirl.create(:book, title: "elephant")
    expect(Searcher.search("elephant")).to include(book.pg_search_document)
  end

  it "matches against book content" do
    book = FactoryGirl.create(:book, content: "tortoise")
    expect(Searcher.search("tortoise")).to include(book.pg_search_document)
  end

  it "by default returns search documents" do
    book = FactoryGirl.create(:book, title: "sheep")
    expect(Searcher.search("sheep")).to include(book.pg_search_document)
  end

  it "can be configured to return AR models" do
    book = FactoryGirl.create(:book, title: "sheep")
    expect(Searcher.search("sheep", resolve: true)).to include(book)
  end
end
