require 'spec_helper'

describe "books/edit" do
  before(:each) do
    @book = assign(:book, stub_model(Book,
      :title => "MyText",
      :content => "MyText"
    ))
  end

  it "renders the edit book form" do
    render

    assert_select "form[action=?][method=?]", book_path(@book), "post" do
      assert_select "textarea#book_title[name=?]", "book[title]"
      assert_select "textarea#book_content[name=?]", "book[content]"
    end
  end
end
