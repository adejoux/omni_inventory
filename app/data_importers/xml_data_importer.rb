require 'elasticsearch'


class XmlDataImporter
  include FileManagement
  attr_reader :es_index, :importer, :filename
  def initialize(importer, filename)
    @filename = filename
    @importer = importer
    @es_index = EsIndex.new(importer.index_name)
  end

  def data_insert(doc, import_document)
    es_index.create_index
    es_index.update_mapping(import_document.data_type, import_document.parent_type)
    doc_id = SecureRandom.hex(5)
    es_index.index_data(doc_id, import_document.data_type, doc, import_document.parent_id, import_document.routing_id )
    doc_id
  end

  def process_data(import_document)
    if import_document.has_one_key?
      import_document.shift_data
      process_data(import_document)
      return
    end
    data_analyzer=DataAnalyzer.build(import_document.data)
    if data_analyzer.blank?
      parent_id = import_document.parent_id
      import_document.previous_document
    else
      doc = data_analyzer.hash_results(import_document.data_type)
      parent_id=data_insert(doc, import_document)
    end

    data_analyzer.key_list.each do |key|
      new_doc=import_document.new_document(key, parent_id)
      puts new_doc.inspect
      process_data( new_doc )
    end
  end

  def perform
    file = [importer.data_dir, filename].join('/')
    begin
      data = open_xml_file(file)
    rescue
      rename_file(importer.data_dir, importer.error_dir, filename)
      return
    end
    process_data( ImportDocument.new(data: data, data_type: importer.index_name) )
    rename_file(importer.data_dir, importer.backup_dir, filename)
  end
end
