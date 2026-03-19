class AddProgramLengthToChapterProgramInformation < ActiveRecord::Migration[6.1]
  def change
    add_reference :chapter_program_information, :program_length, foreign_key: true
  end
end
