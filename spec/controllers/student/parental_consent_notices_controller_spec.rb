require "rails_helper"

RSpec.describe Student::ParentalConsentNoticesController do
  describe "POST #create" do
    it "sends a parental consent notice on behalf of the student" do
      student = FactoryGirl.create(:student)
      sign_in(student)
      controller.request.env["HTTP_REFERER"] = "/somewhere"

      post :create

      mail = ActionMailer::Base.deliveries.last
      expect(mail).to be_present, "no mail sent"
      expect(mail.to).to eq([student.parent_guardian_email])
      expect(mail.subject).to eq("Your daughter needs consent to participate in the Technovation Challenge!")
    end
  end
end
