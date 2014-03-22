class Importer < ActiveRecord::Base
  IMPORT_TYPES = %w[xml csv]

  serialize :unique_fields_list, Array
  validates_presence_of :data_dir, :importer_type, :index_name
  validates :unique_fields_list, array: true
  validates_inclusion_of :importer_type, in: IMPORT_TYPES

  
end
