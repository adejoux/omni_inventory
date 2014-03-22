require 'spec_helper'

describe "Importers" do
  describe "Manage importers" do
    it "Adds a new importer and displays the results" do
      visit importers_url
      expect{
        click_link 'New Importer'
        fill_in 'Data dir', with: "data folder"
        fill_in 'Backup dir', with: "bkp folder"
        fill_in 'Importer type', with: "xml"
        fill_in 'Index name', with: "servers"
        fill_in 'unique_field_1', with: 'name'
        click_button "Create Importer"
      }.to change(Importer,:count).by(1)
      page.should have_content "Importer was successfully created."
      page.should have_content "data folder"
      page.should have_content "bkp folder"
      page.should have_content "xml"
      page.should have_content "servers"
    end
  end
end