require 'spec_helper'

describe ImportersController do
  describe "GET index" do
    it "populates an array of importers" do 
      importer = FactoryGirl.create(:importer) 
      get :index 
      assigns(:importers).should eq([importer]) 
    end 

    it "renders the #index view" do 
      get :index 
      response.should render_template :index 
    end
  end

  describe "GET show" do
    it "assigns the requested importer to @importer" do 
      importer = FactoryGirl.create(:importer) 
      get :show, id: importer 
      assigns(:importer).should eq(importer) 
    end 

    it "renders the #show view" do 
      get :show, id: FactoryGirl.create(:importer) 
      response.should render_template :show 
    end
  end

  describe "GET new" do
    it "assigns a new importer as @importer" do
      get :new
      assigns(:importer).should be_a_new(Importer)
    end
  end

  describe "GET edit" do
    it "assigns the requested importer as @importer" do
      importer = FactoryGirl.create(:importer)
      get :edit, id: importer
      assigns(:importer).should eq(importer)
    end
  end

  describe "POST create" do
    context "with valid attributes" do
      it "creates a new importer" do
        expect{
          post :create, importer: FactoryGirl.attributes_for(:importer)
        }.to change(Importer,:count).by(1)
      end
      
      it "redirects to the new importer" do
        post :create, importer: FactoryGirl.attributes_for(:importer)
        response.should redirect_to Importer.last
      end
    end
    
    context "with invalid attributes" do
      it "does not save the new importer" do
        expect{
          post :create, importer: FactoryGirl.attributes_for(:invalid_importer)
        }.to_not change(Importer,:count)
      end
      
      it "re-renders the new method" do
        post :create, importer: FactoryGirl.attributes_for(:invalid_importer)
        response.should render_template :new
      end
    end

    context "with empty unique fields list" do
      it "does not save the new importer" do
        expect{
          post :create, importer: FactoryGirl.attributes_for(:empty_importer)
        }.to_not change(Importer,:count)
      end
    end
  end

  describe 'PUT update' do
    before :each do
      @importer = FactoryGirl.create(:importer, data_dir: "good_folder", index_name: "good_name")
    end
    
    context "valid attributes" do
      it "located the requested @importer" do
        put :update, id: @importer, importer: FactoryGirl.attributes_for(:importer)
        assigns(:importer).should eq(@importer)      
      end
    
      it "changes @importer's attributes" do
        put :update, id: @importer, 
          importer: FactoryGirl.attributes_for(:importer, data_dir: "new_folder", index_name: "new_name")
        @importer.reload
        @importer.data_dir.should eq("new_folder")
        @importer.index_name.should eq("new_name")
      end
    
      it "redirects to the updated importer" do
        put :update, id: @importer, importer: FactoryGirl.attributes_for(:importer)
        response.should redirect_to @importer
      end
    end
    
    context "invalid attributes" do
      it "locates the requested @importer" do
        put :update, id: @importer, importer: FactoryGirl.attributes_for(:invalid_importer)
        assigns(:importer).should eq(@importer)      
      end
      
      it "does not change @importer's attributes" do
        put :update, id: @importer, 
          importer: FactoryGirl.attributes_for(:importer, data_dir: "new_folder", index_name: nil)
        @importer.reload
        @importer.data_dir.should_not eq("new_folder")
        @importer.index_name.should eq("good_name")
      end
      
      it "re-renders the edit method" do
        put :update, id: @importer, importer: FactoryGirl.attributes_for(:invalid_importer)
        response.should render_template :edit
      end
    end
  end

  describe 'DELETE destroy' do
    before :each do
      @importer = FactoryGirl.create(:importer)
    end
    
    it "deletes the importer" do
      expect{
        delete :destroy, id: @importer        
      }.to change(Importer,:count).by(-1)
    end
      
    it "redirects to importers#index" do
      delete :destroy, id: @importer
      response.should redirect_to importers_url
    end
  end
end
