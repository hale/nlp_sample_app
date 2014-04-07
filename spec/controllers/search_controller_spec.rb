require 'spec_helper'

describe SearchController do

  describe "#index" do
    it "works" do
      get :index
      expect(response).to be_successful
    end

    it "assigns some results" do
      get :index
      expect(assigns(:results)).not_to be_empty
    end

  end

end
