class ReportsController < ApplicationController
  def index
  end

  def new
    es_mapping = EsMapping.new('servers')
    @collections = es_mapping.mappings
  end

  def  load_fields
    @es_mapping = EsMapping.new('servers', es_type: params[:collection] )
    
    @report=Report.new
    
    respond_to do |format|
      format.json { render :json => {:success => true, :html => (render_to_string(partial: "data_fields", layout: false, :formats => :html ))} }
    end
  end

  def show

  end
end
