require "rails_helper"

RSpec.describe RegionalAmbassador::ProfilesController do
  describe "GET #index" do
    it "shows users in the state region for US RAs" do
      FactoryGirl.create(:student, geocoded: "Chicago, IL")
      FactoryGirl.create(:mentor, geocoded: "Evanston, IL")

      wisconsin_ra = FactoryGirl.create(:regional_ambassador, geocoded: "Milwaukee, WI")
      illinois_ra = FactoryGirl.create(:regional_ambassador, geocoded: "Chicago, IL")

      sign_in(illinois_ra)
      get :index
      expect(assigns[:accounts].map(&:id)).not_to include(wisconsin_ra.account_id)
    end

    it "shows users in the country region for Intn'l RAs" do
      us_student = FactoryGirl.create(:student, geocoded: "Chicago, IL")
      riyadh_ra = FactoryGirl.create(:regional_ambassador,
                                     status: :approved,
                                     geocoded: "Dhurma")
      najran_student = FactoryGirl.create(:student, geocoded: "Najran")

      pending_ra = FactoryGirl.create(:ambassador, status: :pending, geocoded: "Dhurma")
      approved_ra = FactoryGirl.create(:ambassador, status: :approved, geocoded: "Dhurma")
      declined_ra = FactoryGirl.create(:ambassador, status: :declined, geocoded: "Dhurma")
      spam_ra = FactoryGirl.create(:ambassador, status: :spam, geocoded: "Dhurma")

      sign_in(riyadh_ra)
      get :index

      expect(assigns[:accounts].map(&:id)).not_to include(us_student.account_id)
      expect(assigns[:accounts].map(&:id)).not_to include(pending_ra.account_id)
      expect(assigns[:accounts].map(&:id)).not_to include(declined_ra.account_id)
      expect(assigns[:accounts].map(&:id)).not_to include(spam_ra.account_id)

      expect(assigns[:accounts].map(&:id)).to include(riyadh_ra.account_id)
      expect(assigns[:accounts].map(&:id)).to include(approved_ra.account_id)
      expect(assigns[:accounts].map(&:id)).to include(najran_student.account_id)
    end
  end
end
