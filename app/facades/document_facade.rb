class DocumentFacade
  def initialize(id)
    es_search = EsQuery.new 
    response = es_search.doc_query(id)
    @doc = response['hits']['hits'].first
  end

  def tabs
    es_mapping = EsMapping.new('servers')
    es_mapping.get_child_types(@doc['_type'])
  end

  def id
    @doc['_id']
  end

  def source
    @doc['_source']
  end

  def  type
    @doc['_type']
  end

end