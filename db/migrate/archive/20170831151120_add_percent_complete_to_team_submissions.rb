class AddPercentCompleteToTeamSubmissions < ActiveRecord::Migration[5.1]
  def up
    unless column_exists?(:team_submissions, :percent_complete)
      add_column :team_submissions,
        :percent_complete,
        :integer,
        null: false,
        default: 0
    end
  end

  def down
    if column_exists?(:team_submissions, :percent_complete)
      remove_column :team_submissions, :percent_complete
    end
  end
end
