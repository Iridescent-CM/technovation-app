require "rails_helper"

RSpec.describe Admin::MentorDropOutsController do
  let(:mentor) { FactoryBot.create(:mentor) }

  before do
    admin = FactoryBot.create(:admin)
    sign_in(admin)
  end

  describe "POST #create" do
    it "runs the job that deletes the current season from the mentor" do
      mentor.account.update(
        seasons: mentor.account.seasons << Season.current.year - 1
      )

      post :create, params: { id: mentor.id }

      expect(mentor.account.reload.seasons).to eq([Season.current.year - 1])
    end

    it "removes any current team memberships" do
      team = FactoryBot.create(:team)
      past_team = FactoryBot.create(:team, seasons: [Season.current.year - 1])

      TeamRosterManaging.add(team, mentor)
      TeamRosterManaging.add(past_team, mentor)

      expect(mentor.reload.teams).to match_array([team, past_team])

      post :create, params: { id: mentor.id }

      expect(mentor.reload.teams).to eq([past_team])
    end

    it "removes them from the mentor CM list" do
      stubbed_subscriber = double(:CreateSendSubscriber)

      allow(CreateSend::Subscriber).to receive(:new)
        .with(
          { api_key: ENV.fetch("CAMPAIGN_MONITOR_API_KEY") },
          ENV.fetch("MENTOR_LIST_ID"),
          mentor.email
      ).and_return(stubbed_subscriber)

      expect(stubbed_subscriber).to receive(:delete)

      post :create, params: { id: mentor.id }
    end

    it "marks the mentor as not searchable" do
      post :create, params: { id: mentor.id }
      expect(mentor.reload).not_to be_searchable
    end
  end
end
