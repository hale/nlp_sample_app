require 'spec_helper'

describe Searcher do
  it "creates ResultSet objects" do
    expect(Searcher.search("foo")).to be_an_instance_of(ResultSet)
  end

  it "matches against book titles" do
    book = FactoryGirl.create(:book, title: "elephant")
    expect(Searcher.search("elephant").results).to include(book)
  end

  it "matches against book content" do
    book = FactoryGirl.create(:book, content: "tortoise")
    expect(Searcher.search("tortoise").results).to include(book)
  end

end
