class SearchsController < ApplicationController
  def index
    if params[:query].present?
      @query=params[:query]
      client = Elasticsearch::Client.new
      body = build_query(params[:query])
      response = client.search body: body
      @response=response
      response = Hashie::Mash.new response

      @hits = response.hits.hits
    end
  end

  private
  def build_query(search)
    {
      query: {
        match: {
          _all: {
            query: search,
            operator: 'and'
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
end
