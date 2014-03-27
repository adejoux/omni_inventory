class DocumentTabFacade < BaseFacade
  def initialize(offset, index, doc_id, parent, type)
    @offset=offset
    @type=type
    @index = index
    es_search = EsQuery.new
    @response = es_search.offset(offset).all_childrens_query(doc_id, parent, type)
  end

  def headers
    es_mapping = EsMapping.new(@index, es_type: @type)
    es_mapping.fields
  end
end
