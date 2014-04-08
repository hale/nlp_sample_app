require 'spec_helper'

describe "search books from /" do

  it "results page contains search query" do
    visit '/'
    fill_in "query", with: "divorces"
    click_button "Search"

    expect(page).to have_content("divorces")
  end

  it "returns results when the query includes a word in the title" do
    FactoryGirl.create(:book, title: "Jade divorces Edward")
    visit '/'
    fill_in "query", with: "divorces"
    click_button "Search"

    expect(page).to have_selector('.book-title', text: "Jade divorces Edward")
  end
end
