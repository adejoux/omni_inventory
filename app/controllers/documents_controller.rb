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

    @id=doc['_id']
    @source=doc['_source']
    @type=doc['_type']

    body = build_child_query(doc['_type'], doc['_id'])

    response = client.search  body: body
    response = Hashie::Mash.new response
    begin
      @parent_tabs = response.aggregations.child_types.buckets.map { |buck| buck['key'] }
    rescue
      @parent_tabs={}
    end
  end

  def load_tab
    client = Elasticsearch::Client.new
    body = build_all_childrens_query(params[:id], params[:parent])
    response = client.search type:params[:type],  body: body

    @response = Hashie::Mash.new response
    mappings = client.indices.get_mapping index: 'servers'
    
    @headers = mappings['servers']['mappings'][params[:type]]['properties'].keys
    
    respond_to do |format|
      format.json { render :json => {:success => true, :html => (render_to_string(partial: 'child_tab', layout: false, :formats => :html ))} }
      format.html { }
    end
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
end
