require 'spec_helper'
require './app/services/select_survey.rb'

RSpec.describe "select survey" do
  it "selects no survey when user not registered" do

    user = double(:user, is_registered: false)
    selected_survey = SelectSurvey.new(user)

    expect(selected_survey.link).to be_empty
  end

  it "selects student survey for students" do
    student = double(:user, role: :student, is_registered: true)
    selected_survey = SelectSurvey.new(student)

    expect(selected_survey.link).to_not be_empty
  end

  it "selects mentor survey for mentors"
  it "selects coach survey for coaches"

  it "selects pre-survey before submission has opened"
  it "selects post-survey after submission has opened"
end
