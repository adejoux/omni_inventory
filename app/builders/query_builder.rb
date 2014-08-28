class QueryBuilder
  def self.fields_by_ids(fields: [], ids: [])
    es_query = EsQuery.new(size: ids.count)
    es_query.search_by_ids(ids, fields)
  end

  def self.paginated_report(offset: offset, fields: fields, type: type, query: query)
    es_query = EsQuery.new(offset: offset,
                           fields: fields + ['_parent'],
                           type: type )

    if query.present?
      es_query.custom_query(query[:main], query[:parent], 'servers')
    else
      es_query.match_all(fields)
    end
  end

  def self.report(fields: fields, type: type, query: query)
    es_query = EsQuery.new(scan: true, type: type )

    if query.present?
      es_query.fields(fields + ['_parent']).custom_query(query[:main], query[:parent], 'servers')
    else
      es_query.fields(report.main_type_array).match_all(report.main_type_array)
    end
  end

  def self.scrolling(scroll)
    client = Elasticsearch::Client.new
    while scroll = client.scroll(scroll_id: scroll['_scroll_id'], scroll: '5m') and not scroll['hits']['hits'].empty?
      yield scroll
    end
  end
end
