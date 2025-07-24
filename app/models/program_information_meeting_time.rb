class ProgramInformationMeetingTime < ActiveRecord::Base
  belongs_to :program_information
  belongs_to :meeting_time
end
