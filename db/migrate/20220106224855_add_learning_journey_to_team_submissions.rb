class AddLearningJourneyToTeamSubmissions < ActiveRecord::Migration[6.1]
  def change
    add_column :team_submissions, :learning_journey, :text
  end
end
