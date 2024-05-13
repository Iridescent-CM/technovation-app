class MeetingTime < ActiveRecord::Base
  has_many :chapter_program_information_meeting_times
  has_many :chapter_program_information, through: :chapter_program_information_meeting_times
end
