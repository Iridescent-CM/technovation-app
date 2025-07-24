class ProgramInformation < ActiveRecord::Base
  self.table_name = "program_information"

  belongs_to :chapterable, polymorphic: true
  belongs_to :program_length
  belongs_to :participant_count_estimate, optional: true
  belongs_to :low_income_estimate, optional: true

  has_many :program_information_organization_types, dependent: :destroy
  has_many :organization_types, through: :program_information_organization_types

  has_many :program_information_meeting_times, dependent: :destroy
  has_many :meeting_times, through: :program_information_meeting_times

  has_many :program_information_meeting_facilitators, dependent: :destroy
  has_many :meeting_facilitators, through: :program_information_meeting_facilitators

  has_many :program_information_meeting_formats, dependent: :destroy
  has_many :meeting_formats, through: :program_information_meeting_formats

  after_save -> { chapterable.update_onboarding_status }

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
