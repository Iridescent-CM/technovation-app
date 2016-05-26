require 'spec_helper'
require './app/services/select_survey.rb'

RSpec.describe "select survey" do
  it "selects no survey when user not registered" do

    user = double(:user, is_registered: false)
    selected_survey = SelectSurvey.new(user)

    expect(selected_survey.link).to be_empty
  end

  context "selects pre-survey before submission has opened" do

    it "selects student survey for students" do
      student = double(:user, role: :student, is_registered: true)
      selected_survey = SelectSurvey.new(student)

      expect(selected_survey.link).to eq("https://www.surveymonkey.com/s/683JH6K")
    end

    it "selects mentor survey for mentors" do
      mentor = double(:user, role: :mentor, is_registered: true)
      selected_survey = SelectSurvey.new(mentor)

      expect(selected_survey.link).to eq("https://www.surveymonkey.com/s/6GLCHTB")
    end

    it "selects coach survey for coaches" do
      coach = double(:user, role: :coach, is_registered: true)
      selected_survey = SelectSurvey.new(coach)

      expect(selected_survey.link).to eq("https://www.surveymonkey.com/s/SV2FST7")
    end
  end

  context "selects post-survey after submission has opened" do

  end
end
