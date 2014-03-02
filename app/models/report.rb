class Report < ActiveRecord::Base

  def main_type_array
    main_type_fields.split(',')
  end

  def parent_type_array
    parent_type_fields.split(',')
  end 
end
