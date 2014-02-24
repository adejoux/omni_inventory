class SearchsController < ApplicationController
  def index
    if params[:query].present?
      @query=params[:query]
      client = Elasticsearch::Client.new
      body = build_query(params[:query])
      response = client.search body: body
      @response = Hashie::Mash.new response
    end
  end

  private
  def build_query(search)
    {
      fields: [],
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
