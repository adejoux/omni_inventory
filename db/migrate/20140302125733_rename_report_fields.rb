class RenameReportFields < ActiveRecord::Migration
  def change
    rename_column :reports, :main_index, :main_type
    rename_column :reports, :main_index_fields, :main_type_fields
    rename_column :reports, :parent_index, :parent_type
    rename_column :reports, :parent_index_fields, :parent_type_fields
  end
end
