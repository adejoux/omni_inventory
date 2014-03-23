class ArrayDataAnalyzer < DataAnalyzer
  def results
    @results ||= []
  end

  def hash_results(key)
    { key => results }
  end
  
  private
  def parse_data
    data.each do |element|
      if element.is_a? Hash
        hash_list << element
      elsif element.is_a? Array
        array_list << element
      else
        results << element
      end
    end
  end
end