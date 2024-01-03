class GmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if !value.match(/^[^@\.][\w\.\-']*(?:\+?[\w\.\-]+)?@gmail\.com$/)
      record.errors.add(attribute, :invalid)
    end
  end
end
