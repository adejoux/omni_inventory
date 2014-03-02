class SearchsController < ApplicationController
  def index
    if params[:query].present?
      @query=params[:query]

      es_query=EsQuery.new
      @response = es_query.offset(offset).search_query(params[:query])

      begin  
        parent_list=@response.aggregations.parent_list.buckets.map { |buck| buck['key'].split('#')[1] }
      rescue
        parent_list=nil
      end

      @paginatable = Kaminari.paginate_array(@response.hits.hits, limit: 10, offset:offset, total_count: @response.hits.total)

      unless parent_list.blank?
        parent_response = es_query.parent_query parent_list
        @parents=Hash.new
        begin
          parent_response.hits.hits.map { |hit| @parents[hit._id]=hit.fields.name}
        rescue
        end
      end

    end
  end 
end
