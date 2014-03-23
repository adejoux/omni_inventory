class ImporterWorker 
  def perform
    Importer.all.each do |importer|
      importer.files.each do |file|
        puts "processing file #{file}\n"
        di=DataImporter.build(importer)
        di.process_file(file)
      end
    end
  end
end