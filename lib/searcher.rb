class Searcher
  def self.search(query, resolve: false)
    results = PgSearch.multisearch(query)
    resolve ? results.map(&:searchable) : results
  end
end
