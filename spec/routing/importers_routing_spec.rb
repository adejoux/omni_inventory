require "spec_helper"

describe ImportersController do
  describe "routing" do

    it "routes to #index" do
      get("/importers").should route_to("importers#index")
    end

    it "routes to #new" do
      get("/importers/new").should route_to("importers#new")
    end

    it "routes to #show" do
      get("/importers/1").should route_to("importers#show", :id => "1")
    end

    it "routes to #edit" do
      get("/importers/1/edit").should route_to("importers#edit", :id => "1")
    end

    it "routes to #create" do
      post("/importers").should route_to("importers#create")
    end

    it "routes to #update" do
      put("/importers/1").should route_to("importers#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/importers/1").should route_to("importers#destroy", :id => "1")
    end

  end
end
