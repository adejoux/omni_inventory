class EsQuery
  attr_reader :client
  def  initialize
    @client = Elasticsearch::Client.new
  end

  def search_query(search)
    @body = build_search_query search
    perform_query
  end
  
  def  doc_query(search)
    @body = build_doc_query search
    perform_query
  end

  def child_query(type, id)
    @body = build_child_query(type, id)
    perform_query
  end

  def parent_query(parent_ids)
    @body = build_search_query parent_ids
    perform_query
  end

  def all_childrens_query(id, parent, type)
    @body = build_all_childrens_query(id, parent)
    perform_query type: type
  end

  def perform_query(type: nil)
    if type
      response = client.search type: type, body: @body
    else
      response = client.search body: @body
    end
    Hashie::Mash.new response
  end

  def build_doc_query(search)
    {
      fields: ['_source', '_parent'],
      query: {
        match: {
          _id: {
            query: search
          }
        }
      }
    }
  end

  def build_all_childrens_query(id, parent)
    {
      query: {
        has_parent: {
          parent_type: parent,
          query: {
            match: {
              _id: id
            }
          }
        }
      }
    }
  end

  def build_child_query(type, id)
    {
      fields: [],
      aggs: {
        child_types: {
          terms: { 
            field: '_type'
          }
        }
      },
      query: {
        has_parent: {
          parent_type: type,
          query: {
            match: {
              _id: id
            }
          }
        }
      }
    }
    
  end

   def build_search_query(search)
    {
      fields: ['_parent'],
      query: {
        match: {
          _all: {
            query: search,
            operator: 'and'
          }
        }
      },
      aggs: {
        parent_list: {
          terms: { 
            field: '_parent'
          }
        }
      },
      highlight: {
        pre_tags: [''],
        post_tags: [''],
        fields: {
          '*' => {}
        }
      }
    }
  end

  def build_parent_query(parent_ids)
    {
      fields: [:name],
      query: {
        terms: {
          _id: parent_ids
        }
      }
    }
  end

end