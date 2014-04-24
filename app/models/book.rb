class Book < ActiveRecord::Base
  include PgSearch
  include RailsNlp
  pg_search_scope :search_title, against: :title
  pg_search_scope :search_content, against: :content
  pg_search_scope :search_title_and_content, against: [:title, :content]
  pg_search_scope :search_title_and_content_with_metaphones, associated_against: {
    :keywords => :metaphone
  }
  pg_search_scope :search_title_and_content_with_stems, associated_against: {
    :keywords => :stem
  }
end
