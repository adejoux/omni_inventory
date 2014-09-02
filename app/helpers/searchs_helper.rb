module SearchsHelper
  def get_doc_id(doc)
    (doc['fields'] && doc['fields']['_parent'] ) || doc['_id']
  end

  def result_title(doc)

    res = ""
    if doc['fields'].present?
      if @parents[ doc['fields']['_parent'] ].present?
        @parents[ doc['fields']['_parent'] ].each do |key, value|
          res << "#{key} #{value.first} "
        end
      else
        primary_fields = YAML.load(ENV['PRIMARY_FIELDS']).map { |field| field }
        primary_fields.each do |field|
          res << "#{field} #{doc['fields'][field].first} "
        end
      end
    end
    res
  end


end
