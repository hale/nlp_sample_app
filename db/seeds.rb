# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#

require "#{Rails.root}/lib/parser.rb"
require 'ruby-progressbar'

books = Parser::Parser.get_books
pbar = ProgressBar.create(title: "DB Seed", total: books.size)

Parser::Parser.get_books.each do |book|
  Book.create(title: book.title, content: book.content)
  pbar.increment
end

