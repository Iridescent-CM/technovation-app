class ChapterProgramInformationMeetingFacilitator < ActiveRecord::Base
  belongs_to :chapter_program_information
  belongs_to :meeting_facilitator
end
