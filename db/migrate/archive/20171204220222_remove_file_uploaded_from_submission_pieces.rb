class RemoveFileUploadedFromSubmissionPieces < ActiveRecord::Migration[5.1]
  def change
    remove_column :business_plans, :file_uploaded, :boolean
    remove_column :business_plans, :remote_file_url, :string

    remove_column :pitch_presentations, :file_uploaded, :boolean
    remove_column :pitch_presentations, :remote_file_url, :string

    remove_column :team_submissions, :source_code_external_url, :string
    remove_column :team_submissions, :source_code_file_uploaded, :boolean
  end
end
