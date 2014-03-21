require 'elasticsearch'
require 'nokogiri'

class XmlImporter
  attr_reader :es_index, :index
  def initialize(index)
    @index = index
    @es_index = EsIndex.new
  end

  def data_insert(doc, data_type: "default", parent_id: nil, parent_type: nil)
    es_index.create_index(index)
    es_index.update_mapping(index, data_type, parent_type) if parent_type
    doc_id = SecureRandom.hex(5)
    if parent_id.blank?
      es_index.index_data(index, doc_id, data_type, doc)
    else
      es_index.index_data_with_parent(index, doc_id, data_type, doc, parent_id)
    end
    doc_id
  end

  def process_data(data, data_type: nil, parent_id: nil, parent_type: nil)
    if data.is_a? Hash and data.keys.count == 1
      process_data(data[data.keys.first], data_type: data_type, parent_id: parent_id,parent_type: parent_type )
      return
    end

    if data.is_a? Hash
      process_hash(data, parent_id,  data_type, parent_type)
    elsif data.is_a? Array
      process_array(data, parent_id, data_type, parent_type)
    end
  end

  def process_hash(data, parent_id, data_type, parent_type)
    #puts "hash parent_id #{parent_id.inspect} data_type: #{data_type} parent_type: #{parent_type}\ndata: #{data.inspect}"

    if data.keys.count == 1
      process_data(data[data.keys.first], data_type: data_type, parent_id: parent_id,parent_type: parent_type )
      return
    end

    doc=Hash.new
    hash_list=Array.new
    array_list=Array.new

    data.each_key  do |key|
      if data[key].is_a? Hash
        hash_list << key
      elsif data[key].is_a? Array
        array_list << key
      else
        doc[key]=data[key]
      end
    end

    unless doc.empty?
      parent_id=data_insert(doc, data_type: data_type, parent_id: parent_id, parent_type: parent_type)
    end

    hash_list.each { |key| process_hash(data[key],parent_id, key, data_type)}
    array_list.each { |value| process_array(data[value],parent_id, value, data_type)}
  end

  def  process_array(data, parent_id, data_type, parent_type)
    #puts "array parent_id #{parent_id.inspect} data_type: #{data_type} parent_type: #{parent_type}\ndata: #{data.inspect}"

    doc={}
    array=[]
    index=0
    data.each do |element|
      if element.class == Hash
        process_hash(element, parent_id, data_type, parent_type)
      elsif element.class  == Array
        process_array(element, parent_id, data_type, parent_type)
      else
        array[index]=element
        index+=1
      end
    end
    unless array.empty?
      doc[data_type]=array
      data_insert(doc, data_type: data_type)
    end
  end

  def process_file(filename)
    doc = Nokogiri.XML(File.open(filename,"rb"))
    data = Hash.from_xml(doc.to_xml)
    process_data(data, data_type: "servers")
  end

end
