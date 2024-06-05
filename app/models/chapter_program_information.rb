class ChapterProgramInformation < ActiveRecord::Base
  self.table_name = "chapter_program_information"

  belongs_to :chapter
  belongs_to :program_length
  belongs_to :participant_count_estimate
  belongs_to :low_income_estimate

  has_many :chapter_program_information_organization_types
  has_many :organization_types, through: :chapter_program_information_organization_types

  has_many :chapter_program_information_meeting_times
  has_many :meeting_times, through: :chapter_program_information_meeting_times

  has_many :chapter_program_information_meeting_facilitators
  has_many :meeting_facilitators, through: :chapter_program_information_meeting_facilitators

  def complete?
    [
      child_safeguarding_policy_and_process,
      team_structure,
      external_partnerships,
      start_date,
      program_model,
      number_of_low_income_or_underserved_calculation,
      program_length,
      participant_count_estimate,
      low_income_estimate,
      organization_types,
      meeting_times,
      meeting_facilitators
    ].all?(&:present?)
  end
end
