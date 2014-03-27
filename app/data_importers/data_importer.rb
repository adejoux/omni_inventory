class DataImporter
  def initialize(importer, file)
  end

  def self.build(importer, file)
    type = "#{importer.importer_type}_data_importer".camelize.to_sym
    const_get(type).new(importer, file)
  end
end
