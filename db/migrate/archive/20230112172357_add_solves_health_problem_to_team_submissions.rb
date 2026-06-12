class AddSolvesHealthProblemToTeamSubmissions < ActiveRecord::Migration[6.1]
  def change
    add_column :team_submissions, :solves_health_problem, :boolean
    add_column :team_submissions, :solves_health_problem_description, :string
  end
end
