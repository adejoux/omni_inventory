class CreateImporters < ActiveRecord::Migration
  def change
    create_table :importers do |t|
      t.string :data_dir
      t.string :backup_dir
      t.string :error_dir
      t.boolean :file_delete
      t.string :importer_type
      t.string :index_name

      t.timestamps
    end
  end
end
