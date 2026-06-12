class ChangeAverageScore < ActiveRecord::Migration[5.1]
  def change
    rename_column :team_submissions, :average_score, :quarterfinals_average_score
  end
end
