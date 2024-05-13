class CreateChapterProgramInformationMeetingTimes < ActiveRecord::Migration[6.1]
  def change
    create_table :chapter_program_information_meeting_times do |t|
      t.references :chapter_program_information, foreign_key: {to_table: :chapter_program_information}, index: {name: "index_cpi_mt_on_chapter_program_information_id"}
      t.references :meeting_time, foreign_key: true, index: {name: "meeting_time_id"}

      t.timestamps
    end
  end
end
