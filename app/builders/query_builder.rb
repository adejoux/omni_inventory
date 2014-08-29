class QueryBuilder
  def self.fields_by_ids(fields: [], ids: [])
    es_query = EsQuery.new(size: ids.count)
    formatted es_query.search_by_ids(ids, fields), fields: fields
  end

  def self.paginated_report(offset: offset, fields: fields, type: type, query: query)
    es_query = EsQuery.new(offset: offset,
                           fields: fields + ['_parent'],
                           type: type )

    if query.present?
      formatted es_query.custom_query(query[:main], query[:parent], 'servers'), fields: fields
    else
      formatted es_query.match_all(fields), fields: fields
    end
  end

  def self.report(fields: fields, type: type, query: query)
    es_query = EsQuery.new(scan: true, type: type )

    if query.present?
      es_query.fields(fields + ['_parent']).custom_query(query[:main], query[:parent], 'servers')
    else
      es_query.fields(fields).match_all(fields)
    end
  end

  def self.scrolling(scroll)
    client = Elasticsearch::Client.new
    while scroll = client.scroll(scroll_id: scroll['_scroll_id'], scroll: '5m') and not scroll['hits']['hits'].empty?
      yield scroll
    end
  end

  def self.get_tab(offset: offset, doc_id: doc_id, parent: parent, type: type)
    es_query = EsQuery.new(offset: offset)
    formatted es_query.all_childrens_query(doc_id, parent, type)
  end

  def self.get_headers(index: index, type: type)
    es_mapping = EsMapping.new(index, es_type: type)
    es_mapping.fields
  end

  def self.search(offset: offset, query: query)
    es_query=EsQuery.new(offset: offset)
    formatted es_query.search_query(query)
  end

  def self.formatted(response, fields: [])
    SearchResultFacade.new(response, fields: fields)
  end

end
