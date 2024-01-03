require "rails_helper"

RSpec.describe "Admin/Data Analysis requests" do
  describe "GET /admin/data_analyses/:top_countries" do
    it "returns the full country names in labels" do
      student = FactoryBot.create(:student)

      sign_in(:admin)
      get admin_data_analysis_path(:top_countries)

      expect(JSON.parse(response.body)["data"]["attributes"]["labels"]).to eq(["United States"])
    end
  end

  describe "GET /admin/data_analyses/:returning_students" do
    it "counts returning students with multiple seasons" do
      student = FactoryBot.create(:student, :past)
      RegisterToCurrentSeasonJob.perform_now(student.account)

      sign_in(:admin)
      get admin_data_analysis_path(:returning_students)

      expect(JSON.parse(response.body)["data"]["attributes"]["data"]).to eq([1, 0])
    end

    it "counts new students to the current season" do
      FactoryBot.create(:student)

      sign_in(:admin)
      get admin_data_analysis_path(:returning_students)

      expect(JSON.parse(response.body)["data"]["attributes"]["data"]).to eq([0, 1])
    end
  end

  describe "GET /admin/data_analyses/:returning_mentors" do
    it "counts returning mentors with multiple seasons" do
      mentor = FactoryBot.create(:mentor, :past)
      RegisterToCurrentSeasonJob.perform_now(mentor.account)

      sign_in(:admin)
      get admin_data_analysis_path(:returning_mentors)

      expect(JSON.parse(response.body)["data"]["attributes"]["data"]).to eq([1, 0])
    end

    it "counts new mentors to the current season" do
      FactoryBot.create(:mentor)

      sign_in(:admin)
      get admin_data_analysis_path(:returning_mentors)

      expect(JSON.parse(response.body)["data"]["attributes"]["data"]).to eq([0, 1])
    end
  end
end
