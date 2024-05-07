class AddParticipantCountEstimateToChapterProgramInformation < ActiveRecord::Migration[6.1]
  def change
    add_reference :chapter_program_information, :participant_count_estimate,
                  foreign_key: true, index: { name: "participant_count_estimate_id" }
  end
end