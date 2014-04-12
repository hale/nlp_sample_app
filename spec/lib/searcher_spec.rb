require 'spec_helper'

describe Searcher do
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

end
