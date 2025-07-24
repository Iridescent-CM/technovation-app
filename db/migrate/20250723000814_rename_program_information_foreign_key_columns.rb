class RenameProgramInformationForeignKeyColumns < ActiveRecord::Migration[6.1]
  def change
    rename_column :program_information_meeting_facilitators, :chapter_program_information_id, :program_information_id
    rename_column :program_information_meeting_times, :chapter_program_information_id, :program_information_id
    rename_column :program_information_organization_types, :chapter_program_information_id, :program_information_id
  end
end
