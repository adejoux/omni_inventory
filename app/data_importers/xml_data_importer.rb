require 'elasticsearch'


class XmlDataImporter
  include FileManagement
  attr_reader :es_index, :importer
  def initialize(importer)
    @importer = importer
    @es_index = EsIndex.new
  end

  def index
    @importer.index_name
  end

  def data_insert(doc, import_document)
    es_index.create_index(index)
    es_index.update_mapping(index, import_document.data_type, import_document.parent_type)
    doc_id = SecureRandom.hex(5)
    if import_document.parent_id.blank?
      es_index.index_data(index, doc_id, import_document.data_type, doc)
    else
      es_index.index_data_with_parent(index, doc_id, import_document.data_type, doc, import_document.parent_id)
    end
    doc_id
  end

  def process_data(import_document)
    if import_document.has_one_key?
      import_document.shift_data
      process_data(import_document)
      return
    end
    data_analyzer=DataAnalyzer.build(import_document.data)
    
    unless data_analyzer.empty?
      doc = data_analyzer.hash_results(import_document.data_type)
      parent_id=data_insert(doc, import_document)
    end

    data_analyzer.key_list.each do |key|
      process_data( import_document.new_document(key, parent_id) )
    end

  end

  def process_file(filename)
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
