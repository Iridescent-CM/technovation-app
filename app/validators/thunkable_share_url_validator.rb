class ThunkableShareUrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if !value.match(/^https?:\/\/x.thunkable.com\/projects\/\w+$/)
      record.errors.add(attribute, :invalid)
    end
  end
end
