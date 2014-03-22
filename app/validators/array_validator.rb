# Validates if Array exists and elements are not nil or empty.
# Allow only string elements
# 
# Example:
#
#   validates :values, array: true
#
class ArrayValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, values)
    if values.blank?
      record.errors[attribute] << "array cannot be nil or empty !"
    end

    Array.wrap(values).each do |value|
      if value.blank?
        record.errors[attribute] << "no empty elements in #{attribute}"
      end

      unless value.class == String
        record.errors[attribute] << "string elements only in #{attribute}"
      end
    end
  end
end