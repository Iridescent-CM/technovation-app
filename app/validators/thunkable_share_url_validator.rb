class ThunkableShareUrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if not value.match(/^https?:\/\/[\w\-_]+\.thunkable.com\/copy\/\w+$/)
      record.errors.add(attribute, :invalid)
    end
  end
end
