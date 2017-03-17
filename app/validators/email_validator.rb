class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if not value.match(/^[^@\.][\w\.\-]+\+{0,1}\w+@[\w\.\-]+\w+$/)
      record.errors.add(attribute, :invalid)
    end
  end
end
