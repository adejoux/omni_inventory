class ReportFacade < BaseFacade
  def initialize(offset, type, fields, query: nil)
    @fields = fields
    es_query = EsQuery.new

    if query.present?
      @response = es_query.offset(offset).es_type(type).fields(fields + ['_parent']).custom_query(query[:main], query[:parent], 'servers')
    else
      @response = es_query.offset(offset).es_type(type).fields(fields).match_all(fields)
    end
  end
end
