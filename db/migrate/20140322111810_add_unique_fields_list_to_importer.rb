class AddUniqueFieldsListToImporter < ActiveRecord::Migration
  def change
    add_column :importers, :unique_fields_list, :string
  end
end
