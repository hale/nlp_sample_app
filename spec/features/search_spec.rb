require 'spec_helper'

def search_for(query: nil, choose: nil)
  visit '/'
  fill_in "query", with: query
  choose(choose)
  click_button "Search"
end

describe "search books from /" do

  before(:each) do
    flexmock(RailsNlp).should_receive(:suggest_stopwords).and_return([]).by_default
  end

  describe "restricting search to certain fields" do
    it "with 'search titles' includes results matching the title"  do
      FactoryGirl.create(:book, title: "Jade divorces Edward")
      search_for(query: "divorces", choose: "search_title")
      expect(page).to have_selector('.book-title', text: "Jade divorces Edward")
    end

    it "with 'search titles' excludes results matching the content" do
      FactoryGirl.create(:book, content: "Jade divorces Edward")
      search_for(query: "divorces", choose: "search_title")
      expect(page).to_not have_selector('.book-title', text: "Jade divorces Edward")
    end

   it "with 'search content' includes results matching the content"  do
      FactoryGirl.create(:book, content: "Jade divorces Edward", title: "not searched")
      search_for(query: "divorces", choose: "search_content")
      expect(page).to have_selector('.book-title', text: "not searched")
    end

    it "with 'search content' excludes results matching the title" do
      FactoryGirl.create(:book, title: "Jade divorces Edward")
      search_for(query: "divorces", choose: "search_content")
      expect(page).to_not have_selector('.book-title', text: "Jade divorces Edward")
    end


    it "with 'search titles and content' includes results matching the title"  do
      FactoryGirl.create(:book, title: "Jade divorces Edward")
      search_for(query: "divorces", choose: "search_title_and_content")
      expect(page).to have_selector('.book-title', text: "Jade divorces Edward")
    end

    it "with 'search titles and content' includes results matching the content" do
      FactoryGirl.create(:book, content: "Jade divorces Edward", title: 'not searched')
      search_for(query: "divorces", choose: "search_title_and_content")
      expect(page).to have_selector('.book-title', text: "not searched")
    end

    it "by default 'search titles' is selected" do
      visit '/'
      expect(page).to have_checked_field("search_title")
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
    choose("search_content")
    click_button "Search"

    expect(page).to have_content("Buttery")
    expect(page).to_not have_content("secret")
  end

  it "can view book from search results page" do
    book = FactoryGirl.create(:book, title: "British bake off")
    visit '/'
    search_for(query: "bake", choose: "search_title")
    click_on "Open Book"

    expect(current_path).to eq(book_path(book))
  end

  describe "removing stop words" do
    it "removes frequently occurring words" do
      RailsNlp.flexmock_teardown
      FactoryGirl.create(:book, title: "the cat is in the hat", content: "it is the best")
      FactoryGirl.create(:book, title: "the rat is on the mat", content: "to is or not to is")
      FactoryGirl.create(:book, title: "the poodle is on the desk")
      FactoryGirl.create(:book, title: "big printer tackles red car")
      flexmock(Searcher).should_receive(:stop_words).and_return(RailsNlp.suggest_stopwords)
      visit '/'
      search_for(query: "who is the best the cat or the rat", choose: "search_title_and_content")

      expect(page).to have_selector(".search-query-stopwords-removed", text: /who best cat or rat/)
    end
  end

  describe "phonetic search" do
    it "gives relevant results when the query contains words with typos" do
      FactoryGirl.create(:book, title: "Auguries of Innocence")
      search_for(query: "augries of innocense", choose: "search_title_and_content_with_metaphones")

      expect(page).to have_selector('.book-title', text: "Auguries of Innocence")
    end
  end
end
