class Report < ActiveRecord::Base

  def main_type_array
    main_type_fields.split(',')
  end

  def parent_type_array
    fields = parent_type_fields || ""
    fields.split(',')
  end

  def fields
    main_type_array + parent_type_array
  end

  def column_maps
    column_maps = []
    main_type_array.each do |value|
      column_maps << { value => :main } 
    end

    parent_type_array.each do |value|
      column_maps <<  { value => :parent } 
    end
    column_maps
  end

end
