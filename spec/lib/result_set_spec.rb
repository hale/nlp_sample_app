require 'spec_helper'

describe ResultSet do

  describe "initialize" do
    it "has a default page number 1" do
      rs = ResultSet.new(query: nil, results: ResultsMock.new)
      expect(rs.page).to eq(1)
    end

    it "assigns the search query" do
      rs = ResultSet.new(query: "test", results: ResultsMock.new)
      expect(rs.query).to eq("test")
    end

    it "has a size equal to the number of results" do
      rs = ResultSet.new(query: nil, results: ResultsMock.new)
      expect(rs.size).to eq(6)
    end
  end

  describe "results" do
    it "limits to 5 per page " do
      rs = ResultSet.new(query: nil, results: ResultsMock.new)
      rs.page = 1
      expect(rs.results.size).to eq(5)
    end
  end

  describe "RailsNLP extras" do
    it "includes the query with stopwords removed" do
      rs = ResultSet.new(query: "the big man", results: ResultsMock.new, query_no_stopwords: "big man")
      expect(rs.query_no_stopwords).to eq("big man")
    end
  end

end

class ResultsMock
  attr_reader :results

  def initialize
    @results = [:one, :two, :three, :four, :five, :six]
  end

  def size
    @results.size
  end

  def page(n)
    self
  end

  def per(n)
    results[0..n-1]
  end
end
