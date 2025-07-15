require "rails_helper"

RSpec.describe "Admin creating an off-platform Chapter Volunteer Agreement for a chapter ambassador" do
  let(:chapter_ambassador) { FactoryBot.create(:chapter_ambassador) }

  context "when the chapter ambassador does not already have a Chapter Volunteer Agreement" do
    before do
      chapter_ambassador.volunteer_agreement.delete
    end

    it "creates an off-platform Chapter Volunteer Agreement" do
      sign_in(:admin)
      visit admin_participant_path(chapter_ambassador.account)

      click_button "Create an off-platform Chapter Volunteer Agreement"

      chapter_ambassador.reload
      expect(chapter_ambassador.volunteer_agreement.off_platform).to be true
    end
  end
end
