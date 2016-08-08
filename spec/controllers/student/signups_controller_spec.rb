require "rails_helper"

RSpec.describe Student::SignupsController do
  describe "POST #create" do
    before do
      post :create, student_account: FactoryGirl.attributes_for(
        :student,
        student_profile_attributes: FactoryGirl.attributes_for(:student_profile),
      )
    end

    it "redirects to the student dashboard" do
      expect(response).to redirect_to(student_dashboard_path)
    end

    it "emails the consent form to the parent" do
      expect(ActionMailer::Base.deliveries.count).not_to be_zero, "no email sent"
      mail = ActionMailer::Base.deliveries.last
      student = StudentAccount.last
      expect(mail.to).to eq([student.parent_guardian_email])
      expect(mail.body.parts.last.to_s).to include(
        "href=\"#{new_parental_consent_url(host: "www.example.com",
                                           token: student.consent_token)}\""
      )
    end
  end
end
