class CreatePitchPresentations < ActiveRecord::Migration
  def change
    create_table :pitch_presentations do |t|
      t.string :uploaded_file
      t.string :remote_file_url
      t.references  :team_submission, null: false
      t.boolean :file_uploaded
      t.timestamps
    end
  end
end
