class BatchFacade < BaseFacade
  def initialize(response, fields)
    @response = response
    @fields = fields
  end
  def results
    @response.hits.hits
  end
end
