class Book < ActiveRecord::Base
  include PgSearch
  multisearchable against: [:title, :content]
end
