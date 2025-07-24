class RenameChapterProgramInformationToProgramInformation < ActiveRecord::Migration[6.1]
  def change
    rename_table :chapter_program_information, :program_information
  end
end
