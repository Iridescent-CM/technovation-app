require 'spec_helper'
require './app/models/select_survey.rb'

RSpec.describe "select survey" do
  context "selects pre-survey before submission has opened" do
    let(:submissions) { double(:submissions, has_opened?: false) }

    it "selects student survey for students" do
      student = double(:user, role: :student, is_registered: true)
      selected_survey = SelectSurvey.new(student, submissions)

      expect(selected_survey.link).to eq("https://www.surveymonkey.com/s/683JH6K")
    end

    it "selects mentor survey for mentors" do
      mentor = double(:user, role: :mentor, is_registered: true)
      selected_survey = SelectSurvey.new(mentor, submissions)

      expect(selected_survey.link).to eq("https://www.surveymonkey.com/s/6GLCHTB")
    end

    it "selects coach survey for coaches" do
      coach = double(:user, role: :coach, is_registered: true)
      selected_survey = SelectSurvey.new(coach, submissions)

      expect(selected_survey.link).to eq("https://www.surveymonkey.com/s/SV2FST7")
    end
  end

  context "selects post-survey after submission has opened" do
    let(:submissions) { double(:submissions, has_opened?: true) }

    it "selects student survey for students" do
      student = double(:user, role: :student, is_registered: true)
      selected_survey = SelectSurvey.new(student, submissions)

      expect(selected_survey.link).to eq("http://rockman.co1.qualtrics.com/SE/?SID=SV_0cankgvZeqVcy3P")
    end

    it "selects mentor survey for mentors" do
      mentor = double(:user, role: :mentor, is_registered: true)
      selected_survey = SelectSurvey.new(mentor, submissions)

      expect(selected_survey.link).to eq("http://rockman.co1.qualtrics.com/SE/?SID=SV_bjRy3xD4O81l6i9")
    end

    it "selects coach survey for coaches" do
      coach = double(:user, role: :coach, is_registered: true)
      selected_survey = SelectSurvey.new(coach, submissions)

      expect(selected_survey.link).to eq("http://rockman.co1.qualtrics.com/SE/?SID=SV_cN166tnJClpa7jf")
    end
  end
end
