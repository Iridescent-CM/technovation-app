require "rails_helper"

RSpec.describe RegionalAmbassador::AccountsController do
  describe "GET #index" do
    it "shows users in the state region for US RAs" do
      skip "this is being reset"
      il_student = FactoryGirl.create(:student) # Chicago is default
      il_mentor = FactoryGirl.create(:mentor, city: "Evanston")

      wisconsin_ra = FactoryGirl.create(:regional_ambassador,
                                        city: "Milwaukee",
                                        state_province: "WI")
      illinois_ra = FactoryGirl.create(:regional_ambassador) # Chicago is default

      sign_in(illinois_ra)

      get :index

      expect(assigns[:accounts].map(&:id)).not_to include(wisconsin_ra.account_id)

      expect(assigns[:accounts].map(&:id)).to include(il_student.account_id)
      expect(assigns[:accounts].map(&:id)).to include(il_mentor.account_id)
    end

    it "shows users in the country region for Intn'l RAs" do
      skip "this is being reset"
      us_student = FactoryGirl.create(:student) # Chicago is default
      riyadh_ra = FactoryGirl.create(:regional_ambassador,
                                     status: :approved,
                                     city: "Dhurma",
                                     state_province: "Riyadh Province",
                                     country: "Saudi Arabia")

      najran_student = FactoryGirl.create(:student,
                                          city: "Najran",
                                          state_province: "Najran Province",
                                          country: "Saudi Arabia")

      pending_ra = FactoryGirl.create(:ambassador,
                                      status: :pending,
                                      city: "Dhurma",
                                      state_province: "Riyadh Province",
                                      country: "Saudi Arabia")

      approved_ra = FactoryGirl.create(:ambassador,
                                       status: :approved,
                                       city: "Dhurma",
                                       state_province: "Riyadh Province",
                                       country: "Saudi Arabia")

      declined_ra = FactoryGirl.create(:ambassador,
                                       status: :declined,
                                       city: "Dhurma",
                                       state_province: "Riyadh Province",
                                       country: "Saudi Arabia")

      spam_ra = FactoryGirl.create(:ambassador,
                                   status: :spam,
                                   city: "Dhurma",
                                   state_province: "Riyadh Province",
                                   country: "Saudi Arabia")

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
