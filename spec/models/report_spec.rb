require 'spec_helper'

describe Report do
  it "has a valid factory" do
    FactoryGirl.create(:report).should be_valid
  end
  it "is invalid without a name" do
    FactoryGirl.build(:report, main_type: nil).should_not be_valid
  end  
  it "is invalid without a main_type" do
    FactoryGirl.build(:report, main_type: nil).should_not be_valid
  end
  it "is invalid without main_type_fields" do
    FactoryGirl.build(:report, main_type_fields: nil).should_not be_valid
  end
end
