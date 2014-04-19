class Book < ActiveRecord::Base
  include PgSearch
  include RailsNlp
  pg_search_scope :search_title, against: :title
  pg_search_scope :search_content, against: :content
  pg_search_scope :search_title_and_content, against: [:title, :content]
end
