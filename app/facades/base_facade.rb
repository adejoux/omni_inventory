class BaseFacade
  def initialize(response, fields)
    @response = response
    @fields = fields
  end

  def total_hits
    @response.hits.total
  end

  def total_time
    @response.took.to_f / 1000
  end

  def results
    @response.hits.hits
  end

  def paginated_results(limit: 10)
    Kaminari.paginate_array(@response.hits.hits, limit: limit, offset: @offset, total_count: total_hits)
  end

  def json_results
    result_hash = Hash.new{|hash, key| hash[key] = Hash.new}
    results.each do |result|
      next if result.fields.blank?
      parent = result.fields._parent ||  nil
      result_hash[result._id][:parent] = parent
      result_hash[result._id][:json] = json_fields(result)
    end
    result_hash
  end

  def parent_list
    @response.hits.hits.map { |hit| hit.fields._parent }.uniq
  end

  private
  def json_fields(result)
    @fields.map do |field|
      begin
        result.fields[field].first
      rescue
        ""
      end
    end
  end
end
