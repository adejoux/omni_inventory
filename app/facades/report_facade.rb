class ReportFacade < BaseFacade
  def initialize(offset, type, fields, filter, ids: nil, query: nil)
    @fields = fields
    es_query = EsQuery.new

    if ids 
      @response = es_query.search_by_ids(ids, fields)
    elsif not query.blank?
      puts query
      puts query[:parent]
      puts query[:main]
      @response = es_query.offset(offset).es_type(type).fields(fields).custom_query(query[:main], query[:parent], 'servers')
    else
      @response = es_query.offset(offset).es_type(type).fields(fields).match_all(fields)
    end
  end

  def json_results 
    result_hash = Hash.new{|hash, key| hash[key] = Hash.new}
    results.each do |result|
      next if result.fields.blank?
      parent = result.fields._parent ||  nil
      result_hash[result._id][:parent] = parent
      result_hash[result._id][:json] = json_fields(result)
    end
    result_hash
  end

  def parent_list
    begin
      @response.aggregations.parent_list.buckets.map { |buck| buck['key'].split('#')[1] }
    rescue
      nil
    end
  end

  private
  def json_fields(result)
    @fields.map do |field|
      begin
        result.fields[field].first
      rescue
        ""
      end
    end
  end
end