class AccountSerializer
  include FastJsonapi::ObjectSerializer
  set_key_transform :camel_lower

  has_one :student_profile, if: ->(record) { record.student_profile }
  has_one :mentor_profile,  if: Proc.new { |record| record.mentor_profile }

  attributes :email, :date_of_birth, :city, :latitude, :longitude, :first_name,
   :last_name, :gender, :referred_by, :referred_by_other

  attribute(:state) do |account|
    if country = Carmen::Country.coded(account.country)
      country.subregions.coded(account.state_province.sub(".", ""))
    end
  end

  attribute(:state_code) do |account|
    account.state_province
  end

  attribute(:country_code) do |account|
    account.country
  end

  attribute(:country) do |account|
    Carmen::Country.coded(account.country).try(:name)
  end
end
