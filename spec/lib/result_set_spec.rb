require 'spec_helper'

describe ResultSet do

  describe "initialize" do
    it "has a default page number 1" do
      rs = ResultSet.new(query: nil, results: ResultsMock.new)
      expect(rs.page).to eq(1)
    end

    it "assigns a search query object" do
      rs = ResultSet.new(query: RailsNlp.expand("test"), results: ResultsMock.new)
      expect(rs.query.to_s).to eq("test")
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

  it "#null_object a gives a null instance" do
    rs = ResultSet.null_object
    expect(rs.results).to eq([])
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
