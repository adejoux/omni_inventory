class Report < ActiveRecord::Base
  serialize :main_index_fields, Array
  serialize :parent_index_fields, Array
end
