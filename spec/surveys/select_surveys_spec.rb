require 'spec_helper'
require './app/models/select_survey.rb'

RSpec.describe "select survey" do
  before do
      allow(SelectSurvey).to receive(:data) { mixed_survey_config }
  end
  context "selects pre-survey before submission has opened" do
    let(:submissions) { double(:submissions, has_opened?: false) }

    it "selects student survey for students" do
      student = double(:user, role: :student, is_registered: true)
      selected_survey = SelectSurvey.new(student, submissions)

      expect(selected_survey.link).to eq("pre survey student")
    end

    it "selects mentor survey for mentors" do
      mentor = double(:user, role: :mentor, is_registered: true)
      selected_survey = SelectSurvey.new(mentor, submissions)

      expect(selected_survey.link).to eq("pre survey mentor")
    end

    it "selects coach survey for coaches" do
      coach = double(:user, role: :coach, is_registered: true)
      selected_survey = SelectSurvey.new(coach, submissions)

      expect(selected_survey.link).to eq("pre survey coach")
    end
  end

  context "selects post-survey after submission has opened" do
    let(:submissions) { double(:submissions, has_opened?: true) }

    it "selects student survey for students" do
      student = double(:user, role: :student, is_registered: true)
      selected_survey = SelectSurvey.new(student, submissions)

      expect(selected_survey.link).to eq("post survey student")
    end

    it "selects mentor survey for mentors" do
      mentor = double(:user, role: :mentor, is_registered: true)
      selected_survey = SelectSurvey.new(mentor, submissions)

      expect(selected_survey.link).to eq("post survey mentor")
    end

    it "selects coach survey for coaches" do
      coach = double(:user, role: :coach, is_registered: true)
      selected_survey = SelectSurvey.new(coach, submissions)

      expect(selected_survey.link).to eq("post survey coach")
    end
  end

  def mixed_survey_config
    {
      :student => {
        :pre => "pre survey student",
        :post => "post survey student"
      },
      :mentor => {
        :pre => "pre survey mentor",
        :post => "post survey mentor"
      },
      :coach => {
        :pre => "pre survey coach",
        :post => "post survey coach"
      }
    }
    end

end
