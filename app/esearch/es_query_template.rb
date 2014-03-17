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

    def match_both(main, parent, type)
      {
        query: {
          bool: {
            must: match_section(main),
            must: has_parent_section(parent, type)
          }
        },
        aggs: parent_list_section
      }
    end

    def multi_match(must)
      {
        query: {
          bool: {
            must: must
          }
        },
        aggs: parent_list_section
      }
    end
    
    def match_parent(parent, type)
      {
        query: has_parent_section(parent, type),
        aggs: parent_list_section
      }
    end

    def match_doc(main)
      {
        query: match_section(main),
        aggs: parent_list_section
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
        },
        aggs: parent_list_section
      }
    end

    def search(search)
      {
        query: {
          match: {
            _all: {
              query: search,
              operator: 'and'
            }
          }
        },
        highlight: highlight_section
      }
    end

    def search_all(search)
      {

        filter: {
          or: [
            {
              query: {
                match: {
                  _all: {
                    query: search,
                    operator: 'and'
                  }
                }
              }
            },
            {
              has_child: {
                type: "lsdf",
                query: {
                  match: {
                    _all: {
                      query: search,
                      operator: 'and'
                    }
                  }
                }
              }
            }
          ]
        }
      }
    end

    def search_by_ids(parent_ids)
      {
        query: {
          terms: {
            _id: parent_ids
          }
        }
      }
    end
  end
end