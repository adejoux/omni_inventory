require 'nokogiri'
module FileManagement
  def rename_file(dir, new_dir, filename)
    file = [dir, filename].join('/')
    new_file = [new_dir, filename].join('/')
    File.rename(file, new_file)
  end

  def open_xml_file(file)
    data = Nokogiri.XML(File.open(file,"rb"))
    Hash.from_xml(data.to_xml)
  end
end