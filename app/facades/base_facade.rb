class BaseFacade
  def total_hits
    @response.hits.total
  end

  def total_time
    @response.took.to_f / 1000
  end

  def results
    Kaminari.paginate_array(@response.hits.hits, limit: 10, offset: @offset, total_count: total_hits)
  end
end