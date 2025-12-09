require "rails_helper"

describe ParentalConsentRequest do
  context "creating a request" do
    it "creates a valid parental consent request" do
      request = FactoryBot.create(:parental_consent_request)

      expect(request).to be_valid
      expect(request.student_profile).to be_present
    end
  end
end
