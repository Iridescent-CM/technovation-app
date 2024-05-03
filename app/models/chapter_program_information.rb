class ChapterProgramInformation < ActiveRecord::Base
  self.table_name = "chapter_program_information"

  belongs_to :chapter

end
