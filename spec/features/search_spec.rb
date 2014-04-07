require 'spec_helper'

describe "search results" do
  it "displays the search query" do
    @book = FactoryGirl.create(:book, title: "Jade divorces Edward")
    visit '/search/new'
    fill_in "Query", with: "divorces"
    click_button "Search"

    expect(page).to have_content("divorces")
  end
end
