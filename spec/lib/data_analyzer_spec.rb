require 'spec_helper'

describe DataAnalyzer do
  context 'Data is a hash' do
    before(:all) do
      @data = {
                test: "entry1", 
                test2: "entry2", 
                test3: ['a1', 'a2', 'a2'], 
                test4: { subtest1: 'v1'}
              }
    end
    

    it 'returns a HashDataAnalyzer object' do
      data_analyzer = DataAnalyzer.build(@data)
      data_analyzer.class.should eq(HashDataAnalyzer)
    end

    it 'should be empty' do
      data_analyzer = DataAnalyzer.build({})
      data_analyzer.empty?.should eq(true)
    end
    
    it 'should return a list of key of array' do
      data_analyzer = DataAnalyzer.build(@data)
      data_analyzer.array_list.should eq([:test3])
    end

    it 'should return a list of key of hash' do
      data_analyzer = DataAnalyzer.build(@data)
      data_analyzer.hash_list.should eq([:test4])
    end

    it 'should have #key_list == #hash_list + #array_list' do
      data_analyzer = DataAnalyzer.build(@data)
      data_analyzer.key_list.should eq(data_analyzer.hash_list + data_analyzer.array_list)
    end

    it 'should give a valid results' do
      data_analyzer = DataAnalyzer.build(@data)
      data_analyzer.results.should eq({test: "entry1", test2: "entry2"})
    end

    it 'should have #hash_results == #results ' do
      data_analyzer = DataAnalyzer.build(@data)
      data_analyzer.hash_results(:test).should eq( data_analyzer.results )
    end
  end

  context 'Data is a array' do
    before(:all) do
      @data = [
                "entry1", 
                "entry2", 
                ['a1', 'a2', 'a2'], 
                { subtest1: 'v1'}
              ]
    end
    
    it 'returns a ArrayDataAnalyzer object' do
      data_analyzer = DataAnalyzer.build([])
      data_analyzer.class.should eq(ArrayDataAnalyzer)
    end

    it 'should be empty' do
      data_analyzer = DataAnalyzer.build([])
      data_analyzer.empty?.should eq(true)
    end

    it 'should return a list of key of array' do
      data_analyzer = DataAnalyzer.build(@data)
      data_analyzer.array_list.should eq([['a1', 'a2', 'a2']])
    end

    it 'should return a list of key of hash' do
      data_analyzer = DataAnalyzer.build(@data)
      data_analyzer.hash_list.should eq([{ subtest1: 'v1'}])
    end

    it 'should give a  valid result' do
      data_analyzer = DataAnalyzer.build(@data)
      data_analyzer.results.should eq( ["entry1", "entry2"] )
    end

    it 'should give a  valid hash result' do
      data_analyzer = DataAnalyzer.build(@data)
      data_analyzer.hash_results(:test).should eq( {:test => ["entry1", "entry2"]} )
    end
  end
end