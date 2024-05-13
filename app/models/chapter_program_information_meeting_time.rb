class ChapterProgramInformationMeetingTime < ActiveRecord::Base
  belongs_to :chapter_program_information
  belongs_to :meeting_time
end
