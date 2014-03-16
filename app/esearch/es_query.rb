class EsQuery
  attr_reader :client
  include EsQueryTemplate
  
  def  initialize
    @client = Elasticsearch::Client.new
    @size = 25
    @fields = []
    @offset = 0
  end

  def es_type(value)
    @type = value
    self
  end
  
  def size(value)
    @size = value
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

  def custom_query(main_query, parent_query, parent_type)
    if main_query.present? && parent_query.present?
      @body = EsQueryTemplate.match_both(main_query, parent_query, parent_type)
    elsif parent_query.present?
      @body = EsQueryTemplate.match_parent(parent_query, parent_type)
    else
      @body = EsQueryTemplate.match_doc(main_query)
    end
    puts @body
    perform_query
  end

  def search_query(search)
    @body = EsQueryTemplate.search search
    fields(['_parent']).perform_query
  end
  
  def  doc_query(search)
    @body = EsQueryTemplate.document search
    fields(['_source', '_parent']).perform_query
  end

  def match_all(selected_fields)
    @body = EsQueryTemplate.match_all
    fields(selected_fields + ['_parent'] ).perform_query
  end

  def search_by_ids(ids, selected_fields)
    @body = EsQueryTemplate.search_by_ids
    fields(selected_fields).perform_query
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
    fields(['_source']).es_type(type).perform_query
  end

  def perform_query
    if @type
      response = client.search size: @size, from: @offset, fields: @fields, type: @type, body: @body
    else
      response = client.search size: @size, from: @offset, fields: @fields, body: @body
    end
    Hashie::Mash.new response
  end
end