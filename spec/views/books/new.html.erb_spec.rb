require 'spec_helper'

describe "books/new" do
  before(:each) do
    assign(:book, flexmock(Book.new,
      :title => "MyText",
      :content => "MyText"
    ))
  end

  it "renders new book form" do
    render

    assert_select "form[action=?][method=?]", books_path, "post" do
      assert_select "textarea#book_title[name=?]", "book[title]"
      assert_select "textarea#book_content[name=?]", "book[content]"
    end
  end
end
