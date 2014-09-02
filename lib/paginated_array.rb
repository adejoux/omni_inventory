# simple class to allow me to use kaminari paginate with my search results
# don't need to split the array but only to make it seems bigger

class PaginatedArray < Array
  def initialize(original_array, offset: 0, limit: nil, total_count: 0)
    @_original_array = original_array
    @offset = offset
    @limit = limit
    @total_count = total_count

    super(original_array || [])
  end

  def current_page
    (@offset / @limit) + 1
  end

  def limit_value
    @limit
  end

  def total_pages
    @total_count / @limit
  end
end
