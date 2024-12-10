class Club < ActiveRecord::Base
  include ActiveGeocoded
  include Casting::Client
  delegate_missing_methods

  belongs_to :primary_contact, class_name: "Account", foreign_key: "primary_account_id", optional: true

  validates :name, presence: true
  validates :summary, length: {maximum: 1000}

  def assign_address_details(geocoded)
    self.city = geocoded.city
    self.state_province = geocoded.state_code
    self.country = geocoded.country_code
  end

end
