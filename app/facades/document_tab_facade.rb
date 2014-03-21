class DocumentTabFacade < BaseFacade
  def initialize(offset, doc_id, parent, type)
    @offset=offset
    @type=type
    es_search = EsQuery.new
    @response = es_search.offset(offset).all_childrens_query(doc_id, parent, type)
    puts @response
  end

  def headers
    index = 'servers'
    es_mapping = EsMapping.new(index, es_type: @type)
    es_mapping.fields
  end
end
