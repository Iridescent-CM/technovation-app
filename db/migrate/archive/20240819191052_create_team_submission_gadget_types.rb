class CreateTeamSubmissionGadgetTypes < ActiveRecord::Migration[6.1]
  def change
    create_table :team_submission_gadget_types do |t|
      t.references :team_submission, foreign_key: true
      t.references :gadget_type, foreign_key: true

      t.timestamps
    end
  end
end
