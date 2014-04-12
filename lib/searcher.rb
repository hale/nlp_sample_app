class Searcher

  FIELD_OPTIONS = [
    TITLE = "title",
    CONTENT = "content",
    TITLE_AND_CONTENT = "title_and_content"
  ]

  def self.search(query: nil, scope: nil)
    raise "cannot search on #{scope}" unless FIELD_OPTIONS.include?(scope)
    results = Book.send("search_#{scope}", query)
    ResultSet.new(query: query, results: results)
  end
end
