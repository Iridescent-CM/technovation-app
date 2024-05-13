class MeetingFacilitator < ActiveRecord::Base
  has_many :chapter_program_information_meeting_facilitators
  has_many :chapter_program_information, through: :chapter_program_information_meeting_facilitators
end
