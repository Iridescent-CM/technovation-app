class PasswordComplexityValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?

    password = value.to_s

    unless password.match?(/[A-Z]/)
      record.errors.add(attribute, :missing_uppercase)
    end

    unless password.match?(/[a-z]/)
      record.errors.add(attribute, :missing_lowercase)
    end

    unless password.match?(/\d/)
      record.errors.add(attribute, :missing_digit)
    end

    local_part = email_local_part(record)
    if local_part.present? && password.downcase.include?(local_part)
      record.errors.add(attribute, :contains_email_local_part)
    end
  end

  private

  def email_local_part(record)
    email = record.email if record.respond_to?(:email)
    return if email.blank?

    email.to_s.split("@").first.to_s.downcase
  end
end
