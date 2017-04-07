class AddSourceCodeFileUploadedConditionalToTeamSubmissions < ActiveRecord::Migration[4.2]
  def change
    add_column :team_submissions, :source_code_file_uploaded, :boolean
  end
end
