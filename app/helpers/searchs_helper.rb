module SearchsHelper
  def link_to_doc(doc)
    begin
      id = doc['fields']['_parent']
    rescue
      id = doc['_id']
    end

    if @parents[id]
      link_to "#{@parents[id].first}", document_path(id)
    else
      link_to "#{doc.highlight.first[0]} #{doc.highlight.first[1]}", document_path(id)
    end
  end
end
