class AddRemindedAboutSurveyCountToAccounts < ActiveRecord::Migration[5.1]
  def change
    add_column :accounts, :reminded_about_survey_count, :integer, null: false, default: 0
  end
end
