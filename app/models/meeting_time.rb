class MeetingTime < ActiveRecord::Base
  has_many :program_information_meeting_times
  has_many :program_information, through: :program_information_meeting_times
end
