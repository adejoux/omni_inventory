require 'spec_helper'

describe Importer do
  it "has a valid factory" do
    FactoryGirl.create(:importer).should be_valid
  end
  it "is invalid without a data_dir" do
    FactoryGirl.build(:importer, data_dir: nil).should_not be_valid
  end

  it "is invalid without a importer_type" do
    FactoryGirl.build(:importer, importer_type: nil).should_not be_valid
  end

  it "is invalid without a index_name" do
    FactoryGirl.build(:importer, index_name: nil).should_not be_valid
  end

  it "is invalid without a valid importer_type" do
    FactoryGirl.build(:importer, importer_type: 'imp').should_not be_valid
  end

  it "is invalid without a unique_fields_list" do
    FactoryGirl.build(:importer, unique_fields_list: nil).should_not be_valid
  end
end
