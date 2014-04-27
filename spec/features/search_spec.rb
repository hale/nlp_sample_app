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
      flexmock(RailsNlp.configuration).should_receive(:fields).and_return(["title", "content"])
      FactoryGirl.create(:book, title: "the cat is in the hat", content: "it is the best")
      FactoryGirl.create(:book, title: "the rat is on the mat", content: "to is or not to is")
      FactoryGirl.create(:book, title: "the poodle is on the desk")
      FactoryGirl.create(:book, title: "big printer tackles red car")
      visit '/'
      search_for(query: "who is the best the cat or the rat", choose: "search_title_and_content")

      expect(page).to have_selector("#query-expanded", text: /who best cat or rat/)
    end

    it "results page displays query with stopwords removed" do
      flexmock(RailsNlp.suggest_stopwords).should_receive(:stop_words).and_return(["foo"])
      visit '/'
      search_for(query: "foo bar", choose: "search_title")
      expect(page).to have_content("bar")
    end
  end

  describe "phonetic search" do
    it "gives relevant results when the query contains words with typos" do
      FactoryGirl.create(:book, title: "Auguries of Innocence")
      visit '/'
      search_for(query: "augries of innocense", choose: "search_title_and_content_with_metaphones")

      expect(page).to have_selector('.book-title', text: "Auguries of Innocence")
    end

    it "displays the phonetic version of the search query" do
      visit '/'
      search_for(query: "food bin", choose: "search_title_and_content_with_metaphones")

      expect(page).to have_content(/FT PN/)
    end
  end

  describe "stem search" do
    it "matches on queries with different inflections from the book text" do
      FactoryGirl.create(:book, title: "Kicking Rose")
      visit '/'
      search_for(query: "kicked", choose: "search_title_and_content_with_stems")

      expect(page).to have_selector('.book-title', text: "Kicking Rose")
    end

    it "displays the stemmed version of the search query" do
      visit '/'
      search_for(query: "running flowers", choose: "search_title_and_content_with_stems")

      expect(page).to have_content(/run flower/)
    end
  end

  describe "search suggestions" do
    it "suggests correct spelling when word is misspelled" do
      FactoryGirl.create(:book, title: "Flowers are nice and other insights")
      visit '/'
      search_for(query: "flowerss and other insights", choose: "search_title")

      expect(page).to have_selector('#search_suggestion', text: "flowers and other insights")
    end

    it "gives no suggestion when word is correctly spelled" do
      visit '/'
      search_for(query: "Everything about this sentence checks out", choose: "search_title_and_content")

      expect(page).to_not have_selector('#search_suggestion')
    end

    it "doesn't suggest anything if none of the words can be corrected" do
      visit '/'
      search_for(query: "ksdhbkvj hbsdfkjhv bksjh", choose: "search_title_and_content")

      expect(page).to_not have_selector('#search_suggestion')
    end

    it "suggests as much of a query as possible: leaves incorrectable words alone" do
      FactoryGirl.create(:book, title: "correctable")
      visit '/'
      search_for(query: "okay notokay correctablee", choose: "search_title")

      expect(page).to have_selector('#search_suggestion', text: "okay notokay correctable")
    end
  end
end
