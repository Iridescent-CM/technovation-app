require "rails_helper"

RSpec.describe ChapterAmbassador::EventJudgeInvitationsController do
  let(:chapter_ambassador) { FactoryBot.create(:chapter_ambassador) }
  let(:event) { FactoryBot.create(:event, ambassador: chapter_ambassador) }

  before do
    sign_in(chapter_ambassador)
  end

  describe "POST #create" do
    it "creates a new user invitation" do
      expect {
        post :create, params: {
          event_id: event.id,
          user_invitation: {
            email: "bluey@test.com"
          }
        }, format: :turbo_stream
      }.to change { UserInvitation.count }.by(1)
    end

    it "does not create a user invitation when the email belongs to an existing account" do
      FactoryBot.create(:judge, account: FactoryBot.create(:account, email: "bingo@test.com"))

      expect {
        post :create, params: {
          event_id: event.id,
          user_invitation: {
            email: "bingo@test.com"
          }
        }, format: :turbo_stream
      }.not_to change { UserInvitation.count }
    end
  end
end
