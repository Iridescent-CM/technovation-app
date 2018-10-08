require "rails_helper"

RSpec.describe "RA/Data Analysis requests" do
  describe "GET /regional_ambassador/data_analyses/:returning_students" do
    it "counts returning students with multiple seasons" do
      student = FactoryBot.create(:student, :past)
      RegisterToCurrentSeasonJob.perform_now(student.account)

      sign_in(:regional_ambassador)
      get regional_ambassador_data_analysis_path(:returning_students)

      expect(JSON.parse(response.body)['data']['attributes']['data']).to eq([1, 0])
    end

    it "counts new students to the current season" do
      FactoryBot.create(:student)

      sign_in(:regional_ambassador)
      get regional_ambassador_data_analysis_path(:returning_students)

      expect(JSON.parse(response.body)['data']['attributes']['data']).to eq([0, 1])
    end
  end

  describe "GET /regional_ambassador/data_analyses/:returning_mentors" do
    it "counts returning mentors with multiple seasons" do
      mentor = FactoryBot.create(:mentor, :past)
      RegisterToCurrentSeasonJob.perform_now(mentor.account)

      sign_in(:regional_ambassador)
      get regional_ambassador_data_analysis_path(:returning_mentors)

      expect(JSON.parse(response.body)['data']['attributes']['data']).to eq([1, 0])
    end

    it "counts new mentors to the current season" do
      FactoryBot.create(:mentor)

      sign_in(:regional_ambassador)
      get regional_ambassador_data_analysis_path(:returning_mentors)

      expect(JSON.parse(response.body)['data']['attributes']['data']).to eq([0, 1])
    end
  end
end