require 'spec_helper'

describe PgSearch do
  it "matches against book titles" do
    book = FactoryGirl.create(:book, title: "elephant")
    expect(PgSearch.multisearch("elephant").first.searchable).to eq(book)
  end

  it "matches against book content" do
    book = FactoryGirl.create(:book, content: "tortoise")
    expect(PgSearch.multisearch("tortoise").first.searchable).to eq(book)
  end
end
