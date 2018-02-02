class AddPercentCompleteToTeamSubmissions < ActiveRecord::Migration[5.1]
  def change
    add_column :team_submissions,
      :percent_complete,
      :integer,
      null: false,
      default: 0
  end
end
