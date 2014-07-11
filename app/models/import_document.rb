class ImportDocument
  attr_accessor :data_type, :parent_id, :parent_type, :routing_id, :grand_parent_type
  attr_reader :data
  def initialize(data: nil, data_type: "default", parent_id: nil, parent_type: nil, routing_id: nil, grand_parent_type: nil)
    @data = data
    @data_type = data_type
    @parent_id =  parent_id
    @parent_type = parent_type
    @grand_parent_type = grand_parent_type
    @routing_id = routing_id
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

  def previous_document
    return if data.class == Array
    @data_type = parent_type
    @parent_type = grand_parent_type
  end

  def new_document(key, new_id)
    new_routing = parent_id unless new_id == parent_id
    if key.class == Hash
      ImportDocument.new(data: key, data_type: data_type, parent_id: parent_id, parent_type: parent_type, routing_id: routing_id )
    else

      @grand_parent_type = parent_type
      ImportDocument.new(data: data[key], data_type: key, parent_id: new_id, parent_type: data_type, routing_id: new_routing, grand_parent_type: grand_parent_type )
    end
  end
end
