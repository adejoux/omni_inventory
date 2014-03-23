class HashDataAnalyzer < DataAnalyzer
  def results
    @results ||= {}
  end

  def hash_results(key)
    results
  end

  private
  def parse_data
    data.each_key  do |key|
      if data[key].is_a? Hash
        hash_list << key
      elsif data[key].is_a? Array
        array_list << key
      else
        results[key]=data[key]
      end
    end
  end
end