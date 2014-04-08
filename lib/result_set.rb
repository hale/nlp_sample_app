class ResultSet

  PER_PAGE = 5

  attr_reader :query, :size
  attr_accessor :page

  def initialize(query: query, documents: documents)
    @query = query
    @documents = documents
    @page = 1
    @size = documents.size
  end

  def models
    documents.map(&:searchable)
  end

  def documents
    @documents.page(@page).per(PER_PAGE)
  end

end
