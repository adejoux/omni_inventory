class EsIndex
  attr_reader :client
  def  initialize
    @client = Elasticsearch::Client.new
  end

  def create_index(index)
    client.indices.create index: index,
    body: {
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
end