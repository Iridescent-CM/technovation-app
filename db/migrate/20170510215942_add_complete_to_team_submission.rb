class AddCompleteToTeamSubmission < ActiveRecord::Migration[5.1]
  def change
    add_column :team_submissions, :complete, :boolean, :null => false, :default => false
  end
end
