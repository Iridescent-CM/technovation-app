class AddCodeOrgAppLabProjectUrlToTeamSubmissions < ActiveRecord::Migration[6.1]
  def change
    add_column :team_submissions, :code_org_app_lab_project_url, :string
  end
end
