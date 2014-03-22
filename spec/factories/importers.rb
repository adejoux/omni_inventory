# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :importer do
    data_dir "MyString"
    backup_dir "MyString"
    error_dir "MyString"
    file_delete false
    importer_type "xml"
    index_name "servers"
    unique_fields_list ['name']
  end
  
  factory :invalid_importer, parent: :importer do |f|
    f.unique_fields_list []
  end

  factory :empty_importer, parent: :importer do |f|
    f.unique_fields_list ['', '']
  end
end
