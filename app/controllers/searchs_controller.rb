class SearchsController < ApplicationController
  def index
    if params[:query].present?
      @query=params[:query]
      client = Elasticsearch::Client.new
      body = build_search_query(params[:query])
      response = client.search body: body
      @response = Hashie::Mash.new response

      begin  
        parent_list=@response.aggregations.parent_list.buckets.map { |buck| buck['key'].split('#')[1] }
      rescue
        parent_list=nil
      end

      if parent_list
        parent_response=client.search body: build_parent_query(parent_list)
        parent_response = Hashie::Mash.new parent_response
        @parents=Hash.new
        begin
          parent_response.hits.hits.map { |hit| @parents[hit._id]=hit.fields.name}
        rescue
        end
      end

    end
  end

  private
  def build_search_query(search)
    {
      fields: ['_parent'],
      query: {
        match: {
          _all: {
            query: search,
            operator: 'and'
          }
        }
      },
      aggs: {
        parent_list: {
          terms: { 
            field: '_parent'
          }
        }
      },
      highlight: {
        pre_tags: [''],
        post_tags: [''],
        fields: {
          '*' => {}
        }
      }
    }
  end

  def build_parent_query(parent_list)
    {
      fields: [:name],
      query: {
        terms: {
          _id: parent_list
        }
      }
    }
  end
end
