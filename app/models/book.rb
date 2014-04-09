class Book < ActiveRecord::Base
  include PgSearch
  pg_search_scope :search, against: [:title]
end
