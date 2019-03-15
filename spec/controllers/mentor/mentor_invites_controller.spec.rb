require "rails_helper"

RSpec.describe Mentor::MentorInvitesController do
  before { SeasonToggles.team_building_enabled! }

  before(:each) do
    SeasonToggles.judging_round = :off
  end

  describe "GET #show" do
    let(:mentor) { FactoryBot.create(:mentor, :onboarded, :geocoded) }
    let!(:invite) { FactoryBot.create(:team_member_invite, invitee: mentor) }

    before do
      sign_in(mentor)
    end

    it "redirects to dashboard and shows a friendly message if judging is enabled" do
      SeasonToggles.judging_round = :qf

      get :show, params: {
        id: invite.invite_token,
        team_member_invite: { status: :pending }
      }

      expect(response).to redirect_to mentor_dashboard_path
      expect(flash[:alert]).to eq(
        "Sorry, but accepting invites is currently disabled because judging has already begun."
      )
      expect(invite.reload).to be_pending
    end

    it "redirects to dashboard and shows a friendly message if between judging rounds" do
      SeasonToggles.judging_round = :between

      get :show, params: {
        id: invite.invite_token,
        team_member_invite: { status: :pending }
      }

      expect(response).to redirect_to mentor_dashboard_path
      expect(flash[:alert]).to eq(
        "Sorry, but accepting invites is currently disabled because judging has already begun."
      )
      expect(invite.reload).to be_pending
    end
  end

  describe "PUT #update" do
    let(:mentor) { FactoryBot.create(:mentor, :onboarded, :geocoded) }
    let!(:invite) { FactoryBot.create(:team_member_invite, invitee: mentor) }

    before do
      sign_in(mentor)
    end

    it "accepts the team member invite" do
      put :update, params: {
        id: invite.invite_token,
        team_member_invite: { status: :accepted }
      }

      expect(invite.reload).to be_accepted
    end

    it "redirects to the mentor team page" do
      put :update, params: {
        id: invite.invite_token,
        team_member_invite: { status: :accepted }
      }

      expect(response).to redirect_to mentor_team_path(invite.team)
    end

    it "shows a friendly message if accepting, but judging is enabled" do
      SeasonToggles.judging_round = :qf

      put :update, params: {
        id: invite.invite_token,
        team_member_invite: { status: :accepted }
      }

      expect(response).to redirect_to mentor_dashboard_path
      expect(flash[:alert]).to eq(
        "Sorry, but accepting invites is currently disabled because judging has already begun."
      )
      expect(invite.reload).to be_pending
    end

    it "shows a friendly message if accepting, but between judging rounds" do
      SeasonToggles.judging_round = :between

      put :update, params: {
        id: invite.invite_token,
        team_member_invite: { status: :accepted }
      }

      expect(response).to redirect_to mentor_dashboard_path
      expect(flash[:alert]).to eq(
        "Sorry, but accepting invites is currently disabled because judging has already begun."
      )
      expect(invite.reload).to be_pending
    end
  end

  describe "PUT #destroy" do
    let(:mentor) { FactoryBot.create(:mentor, :onboarded, :geocoded) }
    let!(:invite) { FactoryBot.create(:team_member_invite, invitee: mentor) }

    before do
      sign_in(mentor)
    end

    it "shows a friendly message if deleting, but judging is enabled" do
      SeasonToggles.judging_round = :qf

      put :destroy, params: {
        id: invite.invite_token
      }

      expect(response).to redirect_to mentor_dashboard_path
      expect(flash[:alert]).to eq(
        "Sorry, but accepting invites is currently disabled because judging has already begun."
      )
      expect(invite.reload).to be_pending
    end

    it "shows a friendly message if deleting, but between judging rounds" do
      SeasonToggles.judging_round = :between

      put :destroy, params: {
        id: invite.invite_token
      }

      expect(response).to redirect_to mentor_dashboard_path
      expect(flash[:alert]).to eq(
        "Sorry, but accepting invites is currently disabled because judging has already begun."
      )
      expect(invite.reload).to be_pending
    end
  end
end
