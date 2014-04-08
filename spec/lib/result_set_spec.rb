require 'spec_helper'

describe ResultSet do

  describe "initialize" do
    it "has a default page number 1" do
      rs = ResultSet.new(query: nil, documents: DocumentsMock.new)
      expect(rs.page).to eq(1)
    end

    it "assigns the search query" do
      rs = ResultSet.new(query: "test", documents: DocumentsMock.new)
      expect(rs.query).to eq("test")
    end

    it "has a size equal to the number of documents" do
      rs = ResultSet.new(query: nil, documents: DocumentsMock.new)
      expect(rs.size).to eq(6)
    end
  end

  describe "documents" do
    it "limits to 5 per page " do
      rs = ResultSet.new(query: nil, documents: DocumentsMock.new)
      rs.page = 1
      expect(rs.documents.size).to eq(5)
    end
  end

  describe "models" do
    it "limits to pages" do
      FactoryGirl.create_list(:book, 6, title: "grass is wet")
      rs = Searcher.search("grass")
      expect(rs.models).to have_exactly(5).items
    end

    it "resolves AR instances" do
      book = FactoryGirl.create(:book, title: "grass")
      rs = Searcher.search("grass")
      expect(rs.models).to include(book)
    end
  end

end

class DocumentsMock
  attr_reader :documents

  def initialize
    @documents = [:one, :two, :three, :four, :five, :six]
  end

  def size
    @documents.size
  end

  def page(n)
    self
  end

  def per(n)
    documents[0..n-1]
  end
end
