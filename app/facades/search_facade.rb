class SearchFacade < BaseFacade
  def initialize(offset, query)
    @offset=offset
    es_query=EsQuery.new
    @response = es_query.offset(offset).search_query(query)
  end
end