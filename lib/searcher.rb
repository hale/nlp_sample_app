class Searcher
  def self.search(query)
    documents = PgSearch.multisearch(query)
    ResultSet.new(query: query, documents: documents)
  end
end
