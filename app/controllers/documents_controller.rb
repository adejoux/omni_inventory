class DocumentsController < ApplicationController
  def show
    es_search = EsQuery.new 
    response = es_search.doc_query(params[:id])
    
    doc = response['hits']['hits'].first
    @id=doc['_id']
    @source=doc['_source']
    @type=doc['_type']

    es_mapping = EsMapping.new('servers')
    @tabs = es_mapping.get_child_types(doc['_type'])
  end

  def load_tab
    es_search = EsQuery.new 
    response = es_search.offset(offset).all_childrens_query(params[:id], params[:parent], params[:type])
    
    @response = Kaminari.paginate_array(response.hits.hits, limit: 10, offset: offset, total_count: response.hits.total)

    es_mapping = EsMapping.new('servers', es_type: params[:type])
    @headers = es_mapping.fields
    
    respond_to do |format|
      format.json { render :json => {:success => true, :html => (render_to_string(partial: 'child_tab', layout: false, :formats => :html ))} }
      format.html { }
    end
  end
end
