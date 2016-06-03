require 'spec_helper'
require './app/models/survey/select_survey.rb'
require './app/models/survey/survey.rb'

RSpec.describe "select survey" do
  before do
      allow(SelectSurvey).to receive(:data) { mixed_survey_config }
  end

  context "selects pre-survey if pre_program_survey is visible" do
    let(:setting) { double(:setting, pre_program_survey_visible?: true, post_program_survey_visible?: false) }

    it "selects student survey for students" do
      student = double(:user, role: :student, is_registered: true)
      selected_survey = SelectSurvey.new(student, setting)

      expect(selected_survey.link).to eq("pre survey student")
    end

    it "selects mentor survey for mentors" do
      mentor = double(:user, role: :mentor, is_registered: true)
      selected_survey = SelectSurvey.new(mentor, setting)

      expect(selected_survey.link).to eq("pre survey mentor")
    end

    it "selects coach survey for coaches" do
      coach = double(:user, role: :coach, is_registered: true)
      selected_survey = SelectSurvey.new(coach, setting)

      expect(selected_survey.link).to eq("pre survey coach")
    end
  end

  context "selects post-survey if post_program_survey_visible is visible" do
    let(:setting) { double(:setting, pre_program_survey_visible?: false, post_program_survey_visible?: true) }

    it "selects student survey for students" do
      student = double(:user, role: :student, is_registered: true)
      selected_survey = SelectSurvey.new(student, setting)

      expect(selected_survey.link).to eq("post survey student")
    end

    it "selects mentor survey for mentors" do
      mentor = double(:user, role: :mentor, is_registered: true)
      selected_survey = SelectSurvey.new(mentor, setting)

      expect(selected_survey.link).to eq("post survey mentor")
    end

    it "selects coach survey for coaches" do
      coach = double(:user, role: :coach, is_registered: true)
      selected_survey = SelectSurvey.new(coach, setting)

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
