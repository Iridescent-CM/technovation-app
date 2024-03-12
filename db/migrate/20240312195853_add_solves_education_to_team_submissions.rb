class AddSolvesEducationToTeamSubmissions < ActiveRecord::Migration[6.1]
  def change
    add_column :team_submissions, :solves_education, :boolean
    add_column :team_submissions, :solves_education_description, :string
  end
end
