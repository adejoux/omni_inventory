require 'spec_helper'

describe ReportBuilder do
  before(:all) do
    es_index = EsIndex.new
    es_index.delete_index :test_index_rspec
    es_index.create_index :test_index_rspec

    test_file = File.join(Rails.root, 'spec', 'data', 'server.json')
    

    json = JSON.parse( IO.read(test_file) )
    es_index.load_data(:test_index_rspec, :servers, json)
  end
    

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

  describe '.total_records' do
    it 'should return 1' do
      expect(report_builder.total_records).to eq(1) 
    end
  end
end