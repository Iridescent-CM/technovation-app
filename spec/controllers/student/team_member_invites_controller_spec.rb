require "rails_helper"

RSpec.describe Student::TeamMemberInvitesController do
  describe "POST #create" do
    let(:student) { FactoryGirl.create(:student, :on_team) }

    let(:invite) { TeamMemberInvite.last }

    before do
      sign_in(student)

      post :create, params: { team_member_invite: {
        invitee_email: "some@student.com",
        team_id: student.team_id,
      } }
    end

    it "sets the invitee email" do
      expect(invite.invitee_email).to eq("some@student.com")
    end

    it "sets the inviter to the student who is signed in" do
      expect(invite.inviter).to eq(student)
    end

    it "sets the team" do
      expect(invite.team).to eq(student.team)
    end

    it "sends the invitation email" do
      mail = ActionMailer::Base.deliveries.last
      expect(mail.to).to eq(["some@student.com"])
      expect(mail.from).to eq(["mailer@technovationchallenge.org"])
      expect(mail.subject).to eq("You're invited to join a Technovation team!")
    end

    it "sets the invitee to an existing account" do
      existing = FactoryGirl.create(:student)

      post :create, params: { team_member_invite: {
        invitee_email: existing.email,
        team_id: student.team_id,
      } }

      expect(invite.invitee).to eq(existing)
    end
  end

  describe "PUT #update" do
    let(:student) { FactoryGirl.create(:student) }
    let!(:invite) { FactoryGirl.create(:team_member_invite, invitee: student) }

    before do
      sign_in(student)
    end

    it "accepts the team member invite" do
      put :update, params: {
        id: invite.invite_token,
        team_member_invite: { status: :accepted }
      }

      expect(invite.reload).to be_accepted
    end

    it "redirects to the student team page" do
      put :update, params: {
        id: invite.invite_token,
        team_member_invite: { status: :accepted }
      }

      expect(response).to redirect_to student_team_path(invite.team)
    end

    it "shows a friendly message if accepting, but already on a team" do
      team = FactoryGirl.create(:team)
      TeamRosterManaging.add(team, student)

      put :update, params: {
        id: invite.invite_token,
        team_member_invite: { status: :accepted }
      }

      expect(response).to redirect_to student_dashboard_path
      expect(flash[:alert]).to eq(
        "You are already on a team, so you cannot accept that invite."
      )
      expect(invite.reload).to be_declined
    end
  end
end
