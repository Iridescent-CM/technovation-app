class EmailValidator < ApplicationValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
      record.errors.add(attribute,
                        I18n.translate(translation_path(record, attribute)))
    end
  end
end
