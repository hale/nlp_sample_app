require 'spec_helper'

def search_for(query: nil, choose: nil)
  visit '/'
  fill_in "query", with: query
  choose(choose)
  click_button "Search"
end

describe "search books from /" do

  describe "restricting search to certain fields" do
    it "with 'search titles' includes results matching the title"  do
      FactoryGirl.create(:book, title: "Jade divorces Edward")
      search_for(query: "divorces", choose: "search_titles")
      expect(page).to have_selector('.book-title', text: "Jade divorces Edward")
    end

    it "with 'search titles' excludes results matching the content" do
      FactoryGirl.create(:book, content: "Jade divorces Edward")
      search_for(query: "divorces", choose: "search_titles")
      expect(page).to_not have_selector('.book-title', text: "Jade divorces Edward")
    end

   it "with 'search content' includes results matching the content"  do
      FactoryGirl.create(:book, content: "Jade divorces Edward")
      search_for(query: "divorces", choose: "search_content")
      expect(page).to have_selector('.book-title', text: "Jade divorces Edward")
    end

    it "with 'search content' excludes results matching the title" do
      FactoryGirl.create(:book, title: "Jade divorces Edward")
      search_for(query: "divorces", choose: "search_content")
      expect(page).to_not have_selector('.book-title', text: "Jade divorces Edward")
    end


    it "with 'search titles and content' includes results matching the title"  do
      FactoryGirl.create(:book, title: "Jade divorces Edward")
      search_for(query: "divorces", choose: "search_titles_and_content")
      expect(page).to have_selector('.book-title', text: "Jade divorces Edward")
    end

    it "with 'search titles and content' excludes results matching the content" do
      FactoryGirl.create(:book, content: "Jade divorces Edward")
      search_for(query: "divorces", choose: "search_titles_and_content")
      expect(page).to have_selector('.book-title', text: "Jade divorces Edward")
    end

    it "by default 'search titles' is selected" do
      visit '/'
      expect(page).to have_checked_field("search_titles")
    end
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

  it "results show the first bit of the content" do
    FactoryGirl.create(:book, content: "#{"Buttery biscuit base"*99*99}secret")
    visit '/'
    fill_in "query", with: "biscuit"
    click_button "Search"

    expect(page).to have_content("Buttery")
    expect(page).to_not have_content("secret")
  end
end
