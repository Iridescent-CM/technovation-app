class ValidateTeamSubmissionAppInventorAppNames < ActiveRecord::Migration[5.1]
  def up
    TeamSubmission.where.not(app_inventor_app_name: nil).find_each do |sub|
      sub.update_column(:app_inventor_app_name, sub.app_inventor_app_name.tr(" ", "_"))
    end
  end
end
