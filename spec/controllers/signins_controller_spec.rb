require "rails_helper"

RSpec.describe SigninsController do
  describe "POST #create" do
    it "is case-insenstive for email" do
      FactoryGirl.create(:student, email: "CapiTalLettERS@gmail.com")

      post :create, account: { email: "capitalletters@gmail.com", password: "secret1234" }
      expect(response).to redirect_to(student_dashboard_path)
    end

    it "sends parent emails for past students registering for this season" do
      student = FactoryGirl.create(:student, :full_profile)
      student.parental_consent.void!
      student.season_registrations.destroy_all

      season = Season.create!(year: Season.current.year - 1)
      SeasonRegistration.register(student.account, season)

      ActionMailer::Base.deliveries.clear

      post :create, account: { email: student.email, password: student.password }

      mail = ActionMailer::Base.deliveries.last
      expect(mail).to be_present, "no parent permission email sent"
      expect(mail.to).to eq([student.parent_guardian_email])
      expect(mail.subject).to include("Your daughter needs permission")

      delete :destroy

      ActionMailer::Base.deliveries.clear

      post :create, account: { email: student.email, password: student.password }

      expect(ActionMailer::Base.deliveries).to be_empty, "another one was sent"
    end
  end
end
