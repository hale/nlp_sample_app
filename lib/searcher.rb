class Searcher

  FIELD_OPTIONS = [
    TITLE = "title",
    CONTENT = "content",
    TITLE_AND_CONTENT = "title_and_content",
    METAPHONES = "title_and_content_with_metaphones",
    STEMS = "title_and_content_with_stems"
  ]

  def self.search(query: query, scope: scope)
    return ResultSet.null_object unless query
    query_expanded = RailsNlp.expand(query)
    query = case scope
              when TITLE, CONTENT, TITLE_AND_CONTENT
                query_expanded.keywords
              when METAPHONES
                query_expanded.metaphones
              when STEMS
                query_expanded.stems
              else raise "cannot search on #{scope}"
              end
    results = Book.send("search_#{scope}", query)
    ResultSet.new(query: query_expanded, results: results, scope: scope)
  end

end
