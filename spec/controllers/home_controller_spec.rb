require 'spec_helper'

describe HomeController do

  describe "#index" do
    it "is root route" do
      assert_recognizes({controller: "home", action: "index"},
                        {:method => "get", :path => "/"})
    end
  end

end
