module EsIndexTemplate
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  module ClassMethods
    def index_tpl
      {
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
  end
end