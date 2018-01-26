class AddBusinessPlanUploaderToTeamSubmissions < ActiveRecord::Migration[5.1]
  def change
    add_column :team_submissions, :business_plan, :string
  end
end
