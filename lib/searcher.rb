class Searcher

  FIELD_OPTIONS = [
    TITLE = "title",
    CONTENT = "content",
    TITLE_AND_CONTENT = "title_and_content",
    METAPHONES = "title_and_content_with_metaphones",
    STEMS = "title_and_content_with_stems"
  ]

  def self.search(query: query, scope: scope)
    return ResultSet.new(query: "", results: [], query_no_stopwords: "") unless query
    query_original = query
    query = case scope
              when TITLE, CONTENT, TITLE_AND_CONTENT
                remove_stopwords(query)
              when METAPHONES
                RailsNlp.metaphones(remove_stopwords(query))
              when STEMS
                RailsNlp.stems(remove_stopwords(query))
              else raise "cannot search on #{scope}"
              end
    results = Book.send("search_#{scope}", query)
    ResultSet.new(query: query_original, results: results, query_no_stopwords: query)
  end

  private

  def self.stop_words
    RailsNlp.suggest_stopwords(n_max: 200)
  end

  def self.remove_stopwords(str)
    (str.split - stop_words).join(" ")
  end
end
