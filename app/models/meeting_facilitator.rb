class MeetingFacilitator < ActiveRecord::Base
  has_many :program_information_meeting_facilitators
  has_many :program_information, through: :program_information_meeting_facilitators
end
