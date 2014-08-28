class ReportIdFacade < BaseFacade
  def initialize(type, fields, ids)
    @fields = fields
    es_query = EsQuery.new

    @response = es_query.size(ids.count).search_by_ids(ids, fields)
  end

  def results
    @response.hits.hits
  end
end
