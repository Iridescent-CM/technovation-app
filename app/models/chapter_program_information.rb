class ChapterProgramInformation < ActiveRecord::Base
  self.table_name = "chapter_program_information"

  belongs_to :chapter
  belongs_to :program_length
  belongs_to :participant_count_estimate
  belongs_to :low_income_estimate
end
