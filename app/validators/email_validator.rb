class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /@/i
      record.errors.add(attribute, :invalid)
    end
  end
end
