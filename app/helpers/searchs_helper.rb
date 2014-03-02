module SearchsHelper
  def get_doc_id(doc)
    begin
      id = doc['fields']['_parent']
    rescue
      id = doc['_id']
    end
  end
end
