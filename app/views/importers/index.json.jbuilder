json.array!(@importers) do |importer|
  json.extract! importer, :id, :data_dir, :backup_dir, :error_dir, :file_delete, :importer_type, :index_name
  json.url importer_url(importer, format: :json)
end
