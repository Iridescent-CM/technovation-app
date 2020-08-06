require "rails_helper"

RSpec.describe "Chapter ambassador/Data Analysis requests" do
  describe "GET /chapter_ambassador/data_analyses/:returning_students" do
    it "counts returning students with multiple seasons" do
      student = FactoryBot.create(:student, :past)
      RegisterToCurrentSeasonJob.perform_now(student.account)

      sign_in(:chapter_ambassador)
      get chapter_ambassador_data_analysis_path(:returning_students)

      expect(JSON.parse(response.body)['data']['attributes']['data']).to eq([1, 0])
    end

    it "counts new students to the current season" do
      FactoryBot.create(:student)

      sign_in(:chapter_ambassador)
      get chapter_ambassador_data_analysis_path(:returning_students)

      expect(JSON.parse(response.body)['data']['attributes']['data']).to eq([0, 1])
    end
  end

  describe "GET /chapter_ambassador/data_analyses/:returning_mentors" do
    it "counts returning mentors with multiple seasons" do
      mentor = FactoryBot.create(:mentor, :past)
      RegisterToCurrentSeasonJob.perform_now(mentor.account)

      sign_in(:chapter_ambassador)
      get chapter_ambassador_data_analysis_path(:returning_mentors)

      expect(JSON.parse(response.body)['data']['attributes']['data']).to eq([1, 0])
    end

    it "counts new mentors to the current season" do
      FactoryBot.create(:mentor)

      sign_in(:chapter_ambassador)
      get chapter_ambassador_data_analysis_path(:returning_mentors)

      expect(JSON.parse(response.body)['data']['attributes']['data']).to eq([0, 1])
    end
  end
end
