class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if not value.match(/^[^@\.][\w\.\-']*(?:\+?[\w\.\-]+)?@[\w\.\-]+\w+$/)
      record.errors.add(attribute, :invalid)
    end
  end
end
