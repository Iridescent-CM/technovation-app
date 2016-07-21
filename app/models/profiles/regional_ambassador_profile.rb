class RegionalAmbassadorProfile < ActiveRecord::Base
  include Authenticatable

  enum status: %i{pending approved rejected}

  validates :organization_company_name, :ambassador_since_year, presence: true
end
