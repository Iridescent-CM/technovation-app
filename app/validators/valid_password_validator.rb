class ValidPasswordValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.blank?
      record.errors.add(attribute, :blank)
    elsif not changes_authenticated?(record, value)
      record.errors.add(attribute, :invalid)
    end
  end

  private
  def changes_authenticated?(record, value)
    if !!record.email_was
      record.class.where(
        "lower(email) = ?",
        record.email_was.downcase
      ).first.authenticate(value)
    else
      record.authenticate(value)
    end
  end
end
