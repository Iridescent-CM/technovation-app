class ProgramInformationMeetingFormat < ActiveRecord::Base
  belongs_to :program_information
  belongs_to :meeting_format
end
