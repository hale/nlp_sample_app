class Searcher
  def self.search(query)
    results = Book.search(query)
    ResultSet.new(query: query, results: results)
  end
end
