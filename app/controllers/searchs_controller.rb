class SearchsController < ApplicationController
  def index
    if params[:query].present?
      @search = QueryBuilder.new.search(offset: offset, query: params[:query])
      @parents = build_parents
    end
  end

  private
  def build_parents
    return Hash.new unless @search.parent_list.present?

    parents = Hash.new{|hash, key| hash[key] = Hash.new}
    response = QueryBuilder.new.fields_by_ids(fields: ['name', 'customer'], ids: @search.parent_list)

    response.results.each do |result|
      parents[result['_id']] = result.fields
    end
    parents
  end
end
