class EsMapping
  attr_reader :index, :es_type

  def initialize(index, es_type: nil)
    @index = index
    @es_type = es_type
    client = Elasticsearch::Client.new
    mappings = Hashie::Mash.new client.indices.get_mapping index: index
    
    @mappings = mappings[index].mappings
  end

  def mappings
    @mappings.keys
  end
  
  def get_all_child_types(parent)
    mappings.map do |mapping|
      next unless get_parent_type(type: mapping) == parent
      mapping
    end
  end

  def get_child_types(parent)
    get_all_child_types(parent).compact
  end

  def fields
    get_fields(es_type)
  end
  
  def has_parent?
    parent_type || false
  end

  def parent_type
    @parent_type ||= get_parent_type
  end

  def parent_fields
    get_fields(parent_type) if has_parent?
  end

  private

  def get_fields(type)
    @mappings.fetch(type).properties_.keys
  end

  def get_parent_type(type: es_type)
    @mappings.fetch(type)._parent_.type 
  end
end