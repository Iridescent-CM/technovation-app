require 'rails_helper'
require './app/models/survey/survey.rb'

RSpec.describe "Surveys" do

  describe ".showing_pre_program_link?" do
    it "reads from pre_program_survey setting" do
      Setting.create!(key: 'pre_program_survey', value: 'false')

      expect(Survey.showing_pre_program_link?).to be false
    end
  end

  describe ".toggle_pre_program" do
    it "toggle pre_program_survey on when it is not showing its link" do
      Setting.create!(key: 'pre_program_survey', value: 'false')

      Survey.toggle_pre_program

      expect(Survey.showing_pre_program_link?).to be true
      expect(Survey.showing_post_program_link?).to be false
    end

    it "toggle pre_program_survey off when it is showing its link" do
      Setting.create!(key: 'pre_program_survey', value: 'true')

      Survey.toggle_pre_program

      expect(Survey.showing_pre_program_link?).to be false
    end
  end

  describe ".toggle_post_program" do
    it "toggle post_program_survey on when it is not showing its link" do
      Setting.create!(key: 'post_program_survey', value: 'false')

      Survey.toggle_post_program

      expect(Survey.showing_post_program_link?). to be true
      expect(Survey.showing_pre_program_link?). to be false
    end

    it "toggle post_program_survey off when it is showing its link" do
      Setting.create!(key: 'post_program_survey', value: 'true')

      Survey.toggle_post_program

      expect(Survey.showing_post_program_link?). to be false
    end
  end

end
