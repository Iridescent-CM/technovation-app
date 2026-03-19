class CreateProgramInformationMeetingFormats < ActiveRecord::Migration[6.1]
  def change
    create_table :program_information_meeting_formats do |t|
      t.references :program_information, foreign_key: { to_table: :program_information }, index: { name: "index_pi_mf_on_program_information_id" }
      t.references :meeting_format, foreign_key: true, index: { name: "meeting_format_id" }

      t.timestamps
    end
  end
end
