require 'spec_helper'

describe ReportBuilder do
  let(:report_builder) { 
    report = FactoryGirl.create(:report)
    ReportBuilder.new(report,0,10)
  }

  it 'should return a ReportBuilder instance' do
    report_builder.should be_kind_of ReportBuilder
  end
  
  describe '.columns' do
    it 'returns the list of  columns' do
      expect(report_builder.columns).to eq(['name', 'name']) 
    end
  end

  describe '.set_search' do
    it 'should return a empty hash' do
      report_builder.set_search({})
      expect(report_builder.search_criterias).to eq ({})
    end
  end

  
end