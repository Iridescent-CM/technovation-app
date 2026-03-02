class RenameChapterProgramInformationJoinerTables < ActiveRecord::Migration[6.1]
  def change
    rename_table :chapter_program_information_meeting_facilitators, :program_information_meeting_facilitators
    rename_table :chapter_program_information_meeting_times, :program_information_meeting_times
    rename_table :chapter_program_information_organization_types, :program_information_organization_types
  end
end
