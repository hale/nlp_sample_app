require 'spec_helper'

describe "search books from /" do

  it "results page contains search query" do
    visit '/'
    fill_in "query", with: "divorces"
    click_button "Search"

    expect(page).to have_selector(".search-query", text: /divorces/)
  end

  it "returns results when the query includes a word in the title" do
    FactoryGirl.create(:book, title: "Jade divorces Edward")
    visit '/'
    fill_in "query", with: "divorces"
    click_button "Search"

    expect(page).to have_selector('.book-title', text: "Jade divorces Edward")
  end

  it "paginates the results" do
    FactoryGirl.create_list(:book, 11, title: "Tragedy eclipses celeb news")
    visit '/'
    fill_in "query", with: "news"
    click_button "Search"

    expect(page).to have_selector('.page', text: '2')
  end

  it "shows how many results were found" do
    FactoryGirl.create_list(:book, 22, title: "Dewford")
    visit '/'
    fill_in "query", with: "Dewford"
    click_button "Search"

    expect(page).to have_selector(".search-results-count", text: /22/)
  end
end
