class MeetingFormat < ActiveRecord::Base
  has_many :program_information_meeting_formats
  has_many :program_information, through: :program_information_meeting_formats
end
