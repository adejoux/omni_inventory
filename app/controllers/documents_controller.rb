class DocumentsController < ApplicationController
  def show
    @doc = DocumentFacade.new(params[:id])

    respond_to do |format|
      format.html
    end
  end

  def load_tab
    @tab = QueryBuilder.get_tab(offset: offset,
                                    doc_id: params[:id],
                                    parent: params[:parent],
                                    type: params[:type])

    @headers = QueryBuilder.get_headers(index: params[:index],
                                        type: params[:type])


    respond_to do |format|
      format.json { render_partial_json('child_tab') }
    end
  end
end
