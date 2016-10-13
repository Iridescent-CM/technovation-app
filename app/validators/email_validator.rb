class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if not value.match(/@/i) or value.match(/\.$/)
      record.errors.add(attribute, :invalid)
    end
  end
end
