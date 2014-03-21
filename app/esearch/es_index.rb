class EsIndex
  include EsIndexTemplate
  attr_reader :client
  def  initialize
    @client = Elasticsearch::Client.new
  end

  def create_index(index)
    return if client.indices.exists index: index
    client.indices.create index: index, body: {
        settings:{
          analysis:{
            analyzer:{
              default_index:{
                type:"custom",
                tokenizer:"standard",
                filter:[ "lowercase", "ngram" ]
              },
              default_search:{
                type:"custom",
                tokenizer:"whitespace",
                filter:[ "lowercase", "asciifolding" ]
              }
            },
            filter:{
              ngram:{
                type:"ngram",
                min_gram:2,
                max_gram:10
              }
            }
          }
        }
      }
  end

  def delete_index(index)
    if index_exists?(index)
      client.indices.delete index: index
    end
  end

  def index_exists?(index)
    client.indices.exists index: index
  end

  def load_data(index, type, body)
    client.index index: index, type: type, body: body
  end

  def index_data(index, id, type, body)
    client.index index: index, id: id, type: type, body: body
  end

  def index_data_with_parent(index, id, type, body, parent)
    client.index index: index, id: id, type: type, body: body, parent: parent
  end

  def update_mapping(index, data_type, parent_type)
    return unless index_exists? index
    result = client.indices.get_mapping index: index
    mappings = result[index]['mappings']

    if mappings[data_type].blank?
      body={ data_type => { "_parent" => { "type" => parent_type } } }
      client.indices.put_mapping index: index, type: data_type, body: body
    end
  end
end
