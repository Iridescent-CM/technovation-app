class RenameOverviewToProjectDetails < ActiveRecord::Migration[6.1]
  def change
    rename_column :submission_scores, :overview_1, :project_details_1
    rename_column :submission_scores, :overview_comment, :project_details_comment
    rename_column :submission_scores, :overview_comment_word_count, :project_details_comment_word_count
  end
end
