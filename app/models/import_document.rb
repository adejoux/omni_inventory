class ImportDocument
  attr_accessor :data_type, :parent_id, :parent_type, :routing
  attr_reader :data
  def initialize(data: nil, data_type: "default", parent_id: nil, parent_type: nil, routing: nil)
    @data = data
    @data_type = data_type
    @parent_id =  parent_id
    @parent_type = parent_type
    @routing = routing
  end

  def first_key
    data.keys.first
  end

  def has_one_key?
    if data.class == Hash && data.keys.count == 1
      true
    else
      false
    end
  end

  def shift_data
    toto = data[first_key]
    @data = toto
  end



  def new_document(key, id)
    routing_id = parent_id unless id == parent_id
    puts data.inspect
    if key.class == Hash
      ImportDocument.new(data: key, data_type: data_type, parent_id: parent_id, parent_type: parent_type, routing: routing )
    else
      ImportDocument.new(data: data[key], data_type: key, parent_id: id, parent_type: data_type, routing: routing_id )
    end
  end
end