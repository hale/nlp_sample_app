class Searcher

  PER_PAGE = 10

  def self.search(query, resolve: false, page: nil)
    results = PgSearch.multisearch(query)
    results = page ? results.page(page).per(PER_PAGE) : results
    results = resolve ? results.map(&:searchable) : results
  end
end
