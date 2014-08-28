class BatchBuilder
  def initialize(report, query, offset: 0)
    @report = report
    @client = Elasticsearch::Client.new
    set_search(query)

    es_query = EsQuery.new

    if search_criterias.present?
      @scroll = es_query.es_type(report.main_type).fields(fields + ['_parent']).custom_query(search_criterias[:main], search_criterias[:parent], 'servers', scan: true)
    else
      @scroll = es_query.es_type(report.main_type).fields(report.main_type_array).match_all(report.main_type_array, scan: true)
    end
  end

  def main_results
    @main_results ||= @search.json_results
  end

  def parent_results
    @parent_results ||= get_parent_results if @report.parent_type
  end

  def get_parent_results
    parent_search = ReportIdFacade.new(@report.parent_type, @report.parent_type_array, @search.parent_list)
    parent_search.json_results
  end

  def each_data
    while @scroll = @client.scroll(scroll_id: @scroll['_scroll_id'], scroll: '5m') and not @scroll['hits']['hits'].empty? do
      @search = BatchFacade.new((Hashie::Mash.new @scroll), @report.main_type_array)
      @main_results=nil
      @parent_results=nil
      results=[]
      main_results.map do |key, value|
        if main_results[key][:parent].blank?
          results += [main_value(key)]
        else
          parent_id = main_results[key][:parent]
          result_key = parent_results[parent_id]
          results += [main_value(key) + parent_value(parent_id)]
        end
      end
      puts results.count
      yield results
    end

  end

  def main_value(key)
    main_results[key][:json] || []
  end

  def parent_value(parent_id)
    parent_results[parent_id][:json] || []
  end

  def total_records
    @search.total_hits
  end

  def total_display_records
    @search.total_hits
  end

  def columns
    @report.fields
  end

  def column_maps
    @column_maps ||= @report.column_maps
  end

  def set_search(search)
    search.select do |key, value|
      next if value.blank?
      indice = key.to_i
      type = column_maps[indice].values.first
      search_criterias[type][columns[indice]]=value
    end
  end

  private
  def search_criterias
    @search_criterias ||= Hash.new{|hash, key| hash[key] = Hash.new}
  end

  def sort_value
    @sort_value ||=  Hash.new{|hash, key| hash[key] = Hash.new}
  end
end
