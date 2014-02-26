class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.string :main_index
      t.string :main_index_fields
      t.string :parent_index
      t.string :parent_index_fields

      t.timestamps
    end
  end
end
