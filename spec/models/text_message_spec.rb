require "rails_helper"

describe TextMessage do
  context "creating a 'parental consent' text message" do
    it "creates a valid parental consent text message" do
      request = FactoryBot.create(:text_message)

      expect(request).to be_valid
      expect(request.account).to be_present
    end
  end
end
