module PhoneNumberValidation
  extend ActiveSupport::Concern
  def format_phone_number(phone_number, country_code)
    Phonelib.parse("#{country_code}#{phone_number}").e164
  end

  def valid_phone_number?(phone_number)
    Phonelib.parse(phone_number).valid?
  end

  def local_phone_number(phone_number)
    Phonelib.parse(phone_number).national
  end

  def friendly_phone_number(phone_number)
    Phonelib.parse(phone_number).full_international
  end
end
