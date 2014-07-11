class Importer < ActiveRecord::Base
  IMPORT_TYPES = %w[xml csv]

  serialize :unique_fields_list, Array
  validates_presence_of :data_dir, :importer_type, :index_name
  validates :unique_fields_list, array: true
  validates_inclusion_of :importer_type, in: IMPORT_TYPES

  def self.import_types
    IMPORT_TYPES
  end

  def files
    Dir.entries(data_dir).select{|x| x.end_with?(importer_type)}
  end

  def import
    files.each do |file|
      puts "processing file #{file} \n"
      di=DataImporter.build(self, file)
      begin
        di.perform
      rescue => e
        puts "ERROR: unable to process file #{e.message}"
      end
    end
  end
end
