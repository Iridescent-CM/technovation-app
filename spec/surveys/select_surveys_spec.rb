require 'spec_helper'
require './app/models/survey.rb'

RSpec.describe "select survey" do
  it "selects no survey when user not registered" do

    user = double(:user, is_registered: false)
    survey = Survey.new(user)

    expect(survey.link).to be_empty
  end

  it "selects student survey for students" do
    student = double(:user, role: :student, is_registered: true)
    survey = Survey.new(student)

    expect(survey.link).to_not be_empty
  end

  it "selects mentor survey for mentors"
  it "selects coach survey for coaches"

  it "selects pre-survey before submission has opened"
  it "selects post-survey after submission has opened"
end
