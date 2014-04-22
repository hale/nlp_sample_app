class ResultSet

  PER_PAGE = 5

  attr_reader :query, :size, :query_no_stopwords
  attr_accessor :page

  def initialize(query: query, results: results, query_no_stopwords: query_no_stopwords)
    @query = query
    @results = results
    @query_no_stopwords = query_no_stopwords
    @page = 1
    @size = results.size
  end

  def results
    @results.page(@page).per(PER_PAGE)
  end

end
