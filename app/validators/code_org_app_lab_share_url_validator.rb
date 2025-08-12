class CodeOrgAppLabShareUrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if !value.match(/^https?:\/\/studio.code.org\/projects\/applab\/.+$/)
      record.errors.add(attribute, :invalid)
    end
  end
end
