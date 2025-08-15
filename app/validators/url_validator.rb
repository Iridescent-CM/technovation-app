class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if !value.match(/^https?:\/\/.+$/)
      record.errors.add(attribute, :invalid)
    end
  end
end
