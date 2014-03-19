class ReportBuilder
  def initialize(report, page, per_page, query)
    @report = report
    set_search(query)
    puts search_criterias.inspect

    offset = (page - 1) * per_page
    @search = ReportFacade.new(offset, report.main_type, report.main_type_array, query: search_criterias)
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

  def data
    main_results.map do |key, value|
      if main_results[key][:parent].blank?
        main_value(key)
      else
        parent_id = main_results[key][:parent]
                puts "id: #{parent_id}"
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
