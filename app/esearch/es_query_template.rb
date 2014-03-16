module EsQueryTemplate
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

    def all_childrens(id, parent)
      {
        query: {
          has_parent: {
            parent_type: parent,
            query: {
              match: {
                _id: id
              }
            }
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
        query: {
          has_parent: {
            parent_type: type,
            query: {
              match: {
                _id: id
              }
            }
          }
        }
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
        aggs: {
          parent_list: {
            terms: { 
              field: '_parent'
            }
          }
        },
        highlight: {
          pre_tags: [''],
          post_tags: [''],
          fields: {
            '*' => {}
          }
        }
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

    def parent(parent_ids)
      {
        fields: [:name],
        query: {
          terms: {
            _id: parent_ids
          }
        }
      }
    end


  end
end