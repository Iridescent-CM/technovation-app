class ChapterProgramInformationOrganizationType < ActiveRecord::Base
  belongs_to :chapter_program_information
  belongs_to :organization_type
end
