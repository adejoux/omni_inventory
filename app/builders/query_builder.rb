class QueryBuilder
  class << self
    def fields_by_ids(fields: [], ids: [])
      es_query = EsQuery.new(size: ids.count)
      formatted es_query.search_by_ids(ids, fields), fields: fields
    end

    def paginated_report(offset: 0, fields: [], type: nil, query: nil)
      es_query = EsQuery.new(offset: offset,
                             fields: fields + ['_parent'],
                             type: type )

      if query.present?
        formatted es_query.custom_query(query[:main], query[:parent], 'servers'), fields: fields
      else
        formatted es_query.match_all(fields), fields: fields
      end
    end

    def report(fields: [], type: nil, query: nil)
      es_query = EsQuery.new(scan: true, type: type )

      if query.present?
        es_query.fields(fields + ['_parent']).custom_query(query[:main], query[:parent], 'servers')
      else
        es_query.fields(fields).match_all(fields)
      end
    end

    def scrolling(scroll)
      client = Elasticsearch::Client.new
      while scroll = client.scroll(scroll_id: scroll['_scroll_id'], scroll: '5m') and not scroll['hits']['hits'].empty?
        yield scroll
      end
    end

    def get_tab(offset: 0, doc_id: 0, parent: nil, type: nil)
      es_query = EsQuery.new(offset: offset)
      formatted es_query.all_childrens_query(doc_id, parent, type)
    end

    def get_headers(index: nil, type: nil)
      es_mapping = EsMapping.new(index, es_type: type)
      es_mapping.fields
    end

    def search(offset: nil, query: nil)
      es_query=EsQuery.new(offset: offset)
      formatted(es_query.search_query(query), offset: offset)
    end

    def formatted(response, fields: [], offset: 0)
      SearchResultFacade.new(response, fields: fields, offset: offset )
    end
  end

end
