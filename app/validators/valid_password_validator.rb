class ValidPasswordValidator < ApplicationValidator
  def validate_each(record, attribute, value)
    unless changes_authenticated?(record, value)
      record.errors.add(attribute,
                        I18n.translate(translation_path(record, attribute)))
    end
  end

  private
  def changes_authenticated?(record, value)
    if !!record.email_was
      record.class.find_by(email: record.email_was).authenticate(value)
    else
      record.authenticate(value)
    end
  end
end
