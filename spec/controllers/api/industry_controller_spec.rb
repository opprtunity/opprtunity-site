require 'spec_helper'

describe Api::IndustryController do
  default_version 1

  describe "GET 'offerings'" do
    it "returns http success" do
      get 'offerings'
      response.should be_success
    end
  end

  describe "GET 'needs'" do
    it "returns http success" do
      get 'needs'
      response.should be_success
    end
  end

end
