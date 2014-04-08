require 'spec_helper'

describe "search books from /" do
  it "results page contains search query" do
    @book = FactoryGirl.create(:book, title: "Jade divorces Edward")
    visit '/'
    fill_in "Query", with: "divorces"
    click_button "Search"

    expect(page).to have_content("divorces")
  end
end
