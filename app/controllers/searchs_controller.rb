class SearchsController < ApplicationController
  def index
    if params[:query].present?
      @search = SearchFacade.new(offset, params[:query])
    end
  end 
end
