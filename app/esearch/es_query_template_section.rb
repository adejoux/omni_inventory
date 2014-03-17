module EsQueryTemplateSection
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  module ClassMethods
    def match_section(query)
      {
        match: query
      }
    end

    def has_parent_section(query, type)
      {
        has_parent: {
          parent_type: type,
          query: {
            match: query
          }
        }
      }
    end

    def parent_list_section
      {
        parent_list: {
          terms: { 
            field: '_parent'
          }
        }
      }
    end

    def highlight_section
      {
        pre_tags: [''],
        post_tags: [''],
        fields: {
          '*' => {}
        }
      }
    end
  end
end