require "rails_helper"

RSpec.describe Student::ParentalConsentNoticesController do
  describe "POST #create" do
    it "sends a parental consent notice on behalf of the student" do
      student = FactoryGirl.create(:student, school_name: "Hello school",
                                             parent_guardian_email: "email@email.com",
                                             parent_guardian_name: "Parent parent")
      sign_in(student)

      post :create

      mail = ActionMailer::Base.deliveries.last
      expect(mail).to be_present, "no mail sent"
      expect(mail.to).to eq(["email@email.com"])
      expect(mail.subject).to include("Your daughter")
    end
  end
end
