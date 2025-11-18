class AddPromotesWellbeingToTeamSubmissions < ActiveRecord::Migration[7.0]
  def change
    add_column :team_submissions, :promotes_wellbeing, :boolean
    add_column :team_submissions, :promotes_wellbeing_description, :string
  end
end
