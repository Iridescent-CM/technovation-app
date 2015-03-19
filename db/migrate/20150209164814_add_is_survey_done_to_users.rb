class AddIsSurveyDoneToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :is_survey_done, :boolean, :null => false, :default => false
  	User.update_all({:is_survey_done => true})
  	emails = CSV.foreach('data/survey/students_with_no_survey.csv', :headers => true).map{|row| row['email address']}
  	User.where(:email => emails).update_all({:is_survey_done => false})
  end
end
