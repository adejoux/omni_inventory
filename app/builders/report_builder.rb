class ReportBuilder
  def initialize(report, query, offset: 0)
    @report = report
    set_search(query)

    response = QueryBuilder.paginated_report(offset: offset,
                                             type: report.main_type,
                                             fields: report.main_type_array,
                                             query: search_criterias)

    @search = BaseFacade.new(response, report.main_type_array)
  end

  def main_results
    @main_results ||= @search.json_results
  end

  def parent_results
    @parent_results ||= get_parent_results if @report.parent_type
  end

  def get_parent_results
    response = QueryBuilder.fields_by_ids(fields: @report.parent_type_array, ids: @search.parent_list)
    parent_search = BaseFacade.new(response, @search.parent_list)
    parent_search.json_results
  end

  def data
    main_results.map do |key, value|
      if main_results[key][:parent].blank?
        main_value(key)
      else
        parent_id = main_results[key][:parent]
        result_key = parent_results[parent_id]
        main_value(key) + parent_value(parent_id)
      end
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
