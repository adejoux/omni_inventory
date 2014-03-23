require 'spec_helper'

describe ImportDocument do
  it "has a valid factory" do
    FactoryGirl.create(:import_document).should be_valid
  end
end