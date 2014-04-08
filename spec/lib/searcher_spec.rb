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

  describe "with page number" do
    it "limits the number of search results returned to 10" do
      FactoryGirl.create_list(:book, 11, title: "father")
      expect(Searcher.search("father", page: 1)).to have_at_most(10).items
    end

    it "by default doesn't resolve" do
      book = FactoryGirl.create(:book, title: "father")
      expect(Searcher.search("father", page: 1)).to_not include(book)
    end
  end

  describe "with resolve: true" do
    it "maps results to AR models" do
      book = FactoryGirl.create(:book, title: "sheep")
      expect(Searcher.search("sheep", resolve: true)).to include(book)
    end

    it "doesn't paginate" do
      FactoryGirl.create_list(:book, 11, title: "sheep")
      expect(Searcher.search("sheep", resolve: true)).to have_exactly(11).items
    end
  end

  describe "with resolve: true and page number" do
    it "maps results to AR models" do
      book = FactoryGirl.create(:book, title: "sheep")
      expect(Searcher.search("sheep", resolve: true, page: 1)).to include(book)
    end

    it "limits results to 10 items" do
      FactoryGirl.create_list(:book, 11, title: "sheep")
      expect(Searcher.search("sheep", resolve: true, page: 2)).to have_exactly(1).items
    end
  end

  describe "defaults" do
    it "doesn't resolve AR models" do
      book = FactoryGirl.create(:book, title: "sheep")
      expect(Searcher.search("sheep")).to include(book.pg_search_document)
    end

    it "doesn't paginate" do
      FactoryGirl.create_list(:book, 11, title: "sheep")
      expect(Searcher.search("sheep")).to have_exactly(11).items
    end
  end
end
