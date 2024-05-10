class OrganizationType < ActiveRecord::Base
  has_many :chapter_program_information_organization_types
  has_many :chapter_program_information, through: :chapter_program_information_organization_types
end
