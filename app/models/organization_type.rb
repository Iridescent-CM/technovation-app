class OrganizationType < ActiveRecord::Base
  has_many :program_information_organization_types
  has_many :program_information, through: :program_information_organization_types
end
