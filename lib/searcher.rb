class Searcher

  FIELD_OPTIONS = [
    TITLE = "title",
    CONTENT = "content",
    TITLE_AND_CONTENT = "title_and_content"
  ]

  def self.search(query: nil, scope: nil)
    raise "cannot search on #{scope}" unless FIELD_OPTIONS.include?(scope)
    return ResultSet.new(query: "", results: [], query_no_stopwords: "") unless query
    query_no_stopwords = (query.split - stop_words).join(" ")
    results = Book.send("search_#{scope}", query_no_stopwords)
    ResultSet.new(query: query, results: results, query_no_stopwords: query_no_stopwords)
  end

  private

  def self.stop_words
    RailsNlp.suggest_stopwords(n: 200)
  end
end
