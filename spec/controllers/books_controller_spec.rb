require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe BooksController do

  describe "GET search" do
    it "works" do
      get :search
      expect(response).to be_successful
    end

    it "assigns some results" do
      get :search
      expect(assigns(:results)).not_to be_nil
    end

    it "assigns the query" do
      get :search, query: "moose"
      expect(assigns(:query)).to eq("moose")
    end

    it "limits results size to 10" do
      FactoryGirl.create_list(:book, 12, title: "a strong man")
      get :search, query: "strong"
      expect(assigns(:results)).to have_at_most(10).items
    end
end

  # This should return the minimal set of attributes required to create a valid
  # Book. As you add validations to Book, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { "title" => "MyText" } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # BooksController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all books as @books" do
      book = Book.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:books)).to eq([book])
    end
  end

  describe "GET show" do
    it "assigns the requested book as @book" do
      book = Book.create! valid_attributes
      get :show, {:id => book.to_param}, valid_session
      expect(assigns(:book)).to eq(book)
    end
  end

  describe "GET new" do
    it "assigns a new book as @book" do
      get :new, {}, valid_session
      expect(assigns(:book)).to be_a_new(Book)
    end
  end

  describe "GET edit" do
    it "assigns the requested book as @book" do
      book = Book.create! valid_attributes
      get :edit, {:id => book.to_param}, valid_session
      expect(assigns(:book)).to eq(book)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Book" do
        expect {
          post :create, {:book => valid_attributes}, valid_session
        }.to change(Book, :count).by(1)
      end

      it "assigns a newly created book as @book" do
        post :create, {:book => valid_attributes}, valid_session
        expect(assigns(:book)).to be_a(Book)
        expect(assigns(:book)).to be_persisted
      end

      it "redirects to the created book" do
        post :create, {:book => valid_attributes}, valid_session
        expect(response).to redirect_to(Book.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved book as @book" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Book).to receive(:save).and_return(false)
        post :create, {:book => { "title" => "invalid value" }}, valid_session
        expect(assigns(:book)).to be_a_new(Book)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Book).to receive(:save).and_return(false)
        post :create, {:book => { "title" => "invalid value" }}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested book" do
        book = Book.create! valid_attributes
        # Assuming there are no other books in the database, this
        # specifies that the Book created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        expect_any_instance_of(Book).to receive(:update).with({ "title" => "MyText" })
        put :update, {:id => book.to_param, :book => { "title" => "MyText" }}, valid_session
      end

      it "assigns the requested book as @book" do
        book = Book.create! valid_attributes
        put :update, {:id => book.to_param, :book => valid_attributes}, valid_session
        expect(assigns(:book)).to eq(book)
      end

      it "redirects to the book" do
        book = Book.create! valid_attributes
        put :update, {:id => book.to_param, :book => valid_attributes}, valid_session
        expect(response).to redirect_to(book)
      end
    end

    describe "with invalid params" do
      it "assigns the book as @book" do
        book = Book.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Book).to receive(:save).and_return(false)
        put :update, {:id => book.to_param, :book => { "title" => "invalid value" }}, valid_session
        expect(assigns(:book)).to eq(book)
      end

      it "re-renders the 'edit' template" do
        book = Book.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Book).to receive(:save).and_return(false)
        put :update, {:id => book.to_param, :book => { "title" => "invalid value" }}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested book" do
      book = Book.create! valid_attributes
      expect {
        delete :destroy, {:id => book.to_param}, valid_session
      }.to change(Book, :count).by(-1)
    end

    it "redirects to the books list" do
      book = Book.create! valid_attributes
      delete :destroy, {:id => book.to_param}, valid_session
      expect(response).to redirect_to(books_url)
    end
  end

end
