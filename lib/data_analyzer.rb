class DataAnalyzer
  attr_reader :data
  def initialize(data)
    @data = data
    parse_data
  end

  def self.build(data)
    type = "#{data.class}_data_analyzer".camelize.to_sym
    puts type
    const_get(type).new(data)
  end

  def hash_list
    @hash_list ||= []
  end

  def array_list
   @array_list ||= []
  end

  def key_list
    hash_list + array_list
  end

  def empty?
    results.empty?
  end
 
  private
  def parse_data
    raise NotImplementedError.new("need to be implemented in child class !")
  end
end