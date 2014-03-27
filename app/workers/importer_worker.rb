class ImporterWorker
  def self.perform
    Importer.all.each do |importer|
      importer.files.each do |file|
        puts "processing file #{file} #{importer.inspect}\n"
        di=DataImporter.build(importer, file)
        begin
          di.perform
        rescue => e
          puts "ERROR: unable to process file #{e.message}"
        end
      end
    end
  end
end
