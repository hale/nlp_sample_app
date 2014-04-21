require 'spec_helper'

describe "books/show" do
  before(:each) do
    @book = assign(:book, flexmock(Book,
      :title => "MyText",
      :content => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
  end
end
