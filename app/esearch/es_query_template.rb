module EsQueryTemplate
  include EsQueryTemplateSection
  class << self
    def document(search)
      {
        query: {
          match: {
            _id: {
              query: search
            }
          }
        }
      }
    end

    def all_childrens(id, type)
      {
        query: has_parent_section( {'_id' => id}, type)
      }
    end

    def multi_match(must)
      {
        query: {
          bool: {
            must: must
          }
        }
      }
    end

    def child(type, id)
      {
        aggs: {
          child_types: {
            terms: {
              field: '_type'
            }
          }
        },
        query: has_parent_section( {'_id' => id}, type)
      }
    end

    def match_all
      {
        query: {
          match_all: { }
        }
      }
    end

    def search(elems)
      {
        query: {
          bool: {
            must: elems
          }
        },
        highlight: highlight_section
      }
    end

    def search_elem(elem)
      {
        match: {
          _all: {
            query: elem
          }
        }
      }
    end

    def search_by_ids(parent_ids)
      {
        query: {
          ids: {
            values: parent_ids
          }
        }
      }
    end
  end
end
