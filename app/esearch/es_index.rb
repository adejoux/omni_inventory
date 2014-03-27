class EsIndex
  include EsIndexTemplate
  attr_reader :client, :index
  def  initialize(index)
    @index = index
    @client = Elasticsearch::Client.new
  end

  def create_index
    return if client.indices.exists index: index
    client.indices.create index: index, body: index_tpl
  end

  def delete_index
    if index_exists?(index)
      client.indices.delete index: index
    end
  end

  def index_exists?
    client.indices.exists index: index
  end

  def index_data(id, type, body, parent = nil, routing = nil)

    if routing.present? && parent.nil?
      raise ArgumentError.new("Cannot define a routing without parent: parent #{parent.inspect} routing #{routing}")
    end

    if routing.present?
      client.index index: index, id: id, type: type, body: body, parent: parent, routing: routing
    elsif parent.present?
      client.index index: index, id: id, type: type, body: body, parent: parent
    else
      client.index index: index, id: id, type: type, body: body
    end
  end

  def not_in_mappings?(type_name)
    mappings[type_name].blank?
  end

  def mappings
    #TODO check it !
    mapp = client.indices.get_mapping index: index
    begin
      mapp[index]['mappings']
    rescue
      {}
    end
  end

  def update_mapping(data_type, parent_type)
    return unless index_exists?
    return if parent_type.blank?

    if parent_type && not_in_mappings?(parent_type)
      raise ArgumentError.new("Cannot define a parent with this undefined type : #{parent_type} !")
    end

    if not_in_mappings?(data_type)
      body={ data_type => { "_parent" => { "type" => parent_type } } }
      client.indices.put_mapping index: index, type: data_type, body: body
    end
  end
end
