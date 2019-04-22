require "rails_helper"

RSpec.describe Attendees do
  describe ".for" do
    let(:ra) { FactoryBot.create(:ambassador) }
    let(:event) { FactoryBot.create(:event, :senior, ambassador: ra) }

    it "finds live event eligible teams" do
      team = FactoryBot.create(:team, :senior, :live_event_eligible)

      FactoryBot.create(:team, :senior, :not_live_event_eligible)

      results = Attendees.for(
        type: "team",
        context: FakeController.new,
        ambassador: ra,
        event: event,
      )

      expect(results.count).to be 1
      expect(results.first.record).to eq(team)
    end

    it "finds live event eligible judges" do
      judge = FactoryBot.create(:judge, :live_event_eligible)
      FactoryBot.create(:regional_ambassador, :has_judge_profile)

      results = Attendees.for(
        type: "account",
        context: FakeController.new,
        ambassador: ra,
        event: event,
      )

      expect(results.count).to be 1
      expect(results.first.record).to eq(judge.account)
    end

    it "finds user invitations" do
      invite = UserInvitation.create!(
        profile_type: :judge,
        email: "invite@me.com"
      )

      results = Attendees.for(
        type: "account",
        query: "invi",
        context: FakeController.new,
        ambassador: ra,
        event: event,
      )

      expect(results.count).to be 1
      expect(results.first.record).to eq(invite)
    end

    it "creates new user invitations with valid emails" do
      results = Attendees.for(
        type: "account",
        query: "invite@me.com",
        context: FakeController.new,
        ambassador: ra,
        event: event,
      )

      expect(results.count).to be 1
      expect(results.first.record.email).to eq("invite@me.com")
    end
  end
end
