class DocumentsController < ApplicationController
  def show
    @doc = DocumentFacade.new(params[:id])
    
    respond_to do |format|
      format.html
    end
  end

  def load_tab
    @tab = DocumentTabFacade.new(offset, params[:id], params[:parent], params[:type]) 
    
    respond_to do |format|
      format.json { render_partial_json('child_tab') }
    end
  end
end
