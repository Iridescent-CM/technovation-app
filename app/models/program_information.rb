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
    case chapterable_type
    when "Club"
      club_complete?
    when "Chapter"
      chapter_complete?
    end
  end

  private

  def club_complete?
    [
      meeting_facilitators,
      meeting_formats,
      meeting_times,
      program_length,
      start_date,
      work_related_ambassador
    ].all?(&:present?)
  end

  def chapter_complete?
    [
      child_safeguarding_policy_and_process,
      meeting_facilitators,
      meeting_times,
      organization_types,
      program_length,
      start_date
    ].all?(&:present?)
  end
end
