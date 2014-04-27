class ResultSet

  PER_PAGE = 5

  attr_reader :query, :size, :scope
  attr_accessor :page

  def initialize(query: query, results: results, scope: scope)
    @query = query
    @results = results
    @page = 1
    @size = results.size
    @scope = scope
  end

  def self.null_object
    self.new(query: "", results: Book.none)
  end

  def results
    @results.page(@page).per(PER_PAGE)
  end

end
