class ReportIdFacade < BaseFacade
  def initialize(type, fields, ids)
    @fields = fields
    es_query = EsQuery.new

    @response = es_query.search_by_ids(ids, fields)
  end
end
