class ChapterProgramInformation < ActiveRecord::Base
  self.table_name = "chapter_program_information"

  belongs_to :chapter
  belongs_to :program_length
  belongs_to :participant_count_estimate
  belongs_to :low_income_estimate

  has_many :chapter_program_information_organization_types

  has_many :organization_types,
           through: :chapter_program_information_organization_types
end
