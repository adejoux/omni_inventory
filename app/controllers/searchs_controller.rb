class SearchsController < ApplicationController
  def index
    if params[:query].present?
      @search = QueryBuilder.search(offset: offset, query: params[:query])
    end
  end
end
