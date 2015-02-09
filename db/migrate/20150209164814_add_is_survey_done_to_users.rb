class AddIsSurveyDoneToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :is_survey_done, :boolean, :null => false, :default => false
  end
end
