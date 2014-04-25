class ResultSet

  PER_PAGE = 5

  attr_reader :query, :size
  attr_accessor :page

  def initialize(query: query, results: results)
    @query = query
    @results = results
    @page = 1
    @size = results.size
  end

  def self.null_object
    self.new(query: "", results: Book.none)
  end

  def results
    @results.page(@page).per(PER_PAGE)
  end

end
