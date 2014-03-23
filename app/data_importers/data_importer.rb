class DataImporter
  def initialize(importer)
  end

  def self.build(importer)
    type = "#{importer.importer_type}_data_importer".camelize.to_sym
    puts type
    const_get(type).new(importer)
  end
end