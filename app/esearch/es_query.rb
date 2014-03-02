class EsQuery
  attr_reader :client
  def  initialize
    @client = Elasticsearch::Client.new
    @size = 10
    @fields = []
    @offset = 0
  end

  def size(value)
    @size = size
    self
  end

  def offset(value)
    @offset = value
    self
  end

  def fields(field_list)
    @fields = field_list
    self
  end

  def search_query(search)
    @body = EsQueryTemplate.search search
    fields(['_parent']).perform_query
  end
  
  def  doc_query(search)
    @body = EsQueryTemplate.document search
    fields(['_source', '_parent']).perform_query
  end

  def child_query(type, id)
    @body = EsQueryTemplate.child(type, id)
    perform_query
  end

  def parent_query(parent_ids)
    @body = EsQueryTemplate.search parent_ids
    perform_query
  end

  def all_childrens_query(id, parent, type)
    @body = EsQueryTemplate.all_childrens(id, parent)
    fields(['_source']).perform_query type: type
  end

  def perform_query(type: nil)
    if type
      response = client.search size: @size, from: @offset, fields: @fields, type: type, body: @body
    else
      response = client.search size: @size, from: @offset, fields: @fields, body: @body
    end
    Hashie::Mash.new response
  end
end