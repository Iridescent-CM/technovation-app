class CreateChapterProgramInformationMeetingFacilitators < ActiveRecord::Migration[6.1]
  def change
    create_table :chapter_program_information_meeting_facilitators do |t|
      t.references :chapter_program_information, foreign_key: {to_table: :chapter_program_information}, index: {name: "index_cpi_mf_on_chapter_program_information_id"}
      t.references :meeting_facilitator, foreign_key: true, index: {name: "meeting_facilitator_id"}

      t.timestamps
    end
  end
end
