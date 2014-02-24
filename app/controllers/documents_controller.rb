class DocumentsController < ApplicationController
  def show
    client = Elasticsearch::Client.new
    body = build_query(params[:id])
    response = client.search  body: body
    
    begin 
      doc = response['hits']['hits'].first
    rescue
      raise ActionController::RoutingError.new('Not Found')
    end

    begin
      parent = doc['fields']['_parent']
    rescue
    end

    if parent
      redirect_to document_path(parent)
    end

    @source=doc['_source']
    body = build_child_query(doc['_type'], doc['_id'])

    response = client.search  body: body
    dfgh
  end
  private
  def build_query(search)
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

  def build_child_query(type, id)
    {
      fields: [],
      aggs: {
        child_ids: {
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
end
