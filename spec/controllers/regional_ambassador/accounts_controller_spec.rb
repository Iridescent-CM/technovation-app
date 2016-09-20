require "rails_helper"

RSpec.describe RegionalAmbassador::AccountsController do
  describe "GET #index" do
    it "shows users in the state region for US RAs" do
      FactoryGirl.create(:student, geocoded: "Chicago, IL")
      FactoryGirl.create(:mentor, geocoded: "Evanston, IL")

      wisconsin_ra = FactoryGirl.create(:regional_ambassador, geocoded: "Milwaukee, WI")
      illinois_ra = FactoryGirl.create(:regional_ambassador, geocoded: "Chicago, IL")

      sign_in(illinois_ra)
      get :index
      expect(assigns[:accounts].map(&:id)).not_to include(wisconsin_ra.id)
    end

    it "shows users in the country region for Intn'l RAs" do
      us_student = FactoryGirl.create(:student, geocoded: "Chicago, IL")
      riyadh_ra = FactoryGirl.create(:regional_ambassador, geocoded: "Dhurma")
      najran_student = FactoryGirl.create(:student, geocoded: "Najran")

      sign_in(riyadh_ra)
      get :index

      expect(assigns[:accounts].map(&:id)).not_to include(us_student.id)
      expect(assigns[:accounts].map(&:id)).to include(riyadh_ra.id)
      expect(assigns[:accounts].map(&:id)).to include(najran_student.id)
    end
  end
end
