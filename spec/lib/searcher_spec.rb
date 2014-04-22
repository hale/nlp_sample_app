require 'spec_helper'

describe Searcher do

  before(:each) do
    flexmock(RailsNlp).should_receive(:suggest_stopwords).and_return([]).by_default
  end

  it "creates ResultSet objects" do
    expect(Searcher.search(query: "foo", scope: "title")).to be_an_instance_of(ResultSet)
  end

  it "can search on titles" do
    book = FactoryGirl.create(:book, title: "elephant")
    FactoryGirl.create(:book, content: "elephant")
    expect(Searcher.search(query: "elephant", scope: "title").results).to eq([book])
  end

  it "can search on content" do
    FactoryGirl.create(:book, title: "elephant")
    book = FactoryGirl.create(:book, content: "elephant")
    expect(Searcher.search(query: "elephant", scope: "content").results).to eq([book])
  end

  it "can search on content and titles" do
    book2 = FactoryGirl.create(:book, title: "elephant")
    book1 = FactoryGirl.create(:book, content: "elephant")
    expect(Searcher.search(query: "elephant", scope: "title_and_content").results).to include(book1, book2)
  end

  it "takes stop_words, removes them from query before searching" do
    flexmock(RailsNlp).should_receive(:suggest_stopwords).and_return(["the"])
    flexmock(Book).should_receive(:search_title).with("brown fox").and_return([])
    Searcher.search(query: "the brown fox", scope: "title")
  end

end
