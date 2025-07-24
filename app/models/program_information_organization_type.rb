class ProgramInformationOrganizationType < ActiveRecord::Base
  belongs_to :program_information
  belongs_to :organization_type
end
