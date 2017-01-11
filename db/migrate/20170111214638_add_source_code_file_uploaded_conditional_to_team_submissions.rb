class AddSourceCodeFileUploadedConditionalToTeamSubmissions < ActiveRecord::Migration
  def change
    add_column :team_submissions, :source_code_file_uploaded, :boolean
  end
end
