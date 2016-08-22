require "rails_helper"

RSpec.describe Student::TeamMemberInvitesController do
  describe "POST #create" do
    let(:student) { FactoryGirl.create(:student, :on_team) }

    let(:invite) { TeamMemberInvite.last }

    before do
      sign_in(student)

      post :create, team_member_invite: {
        invitee_email: "some@student.com",
        team_id: student.team_id,
      }
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
      expect(mail.from).to eq(["info@technovationchallenge.org"])
      expect(mail.subject).to eq("You're invited to join a Technovation team!")
    end

    it "sets the invitee to an existing account" do
      existing = FactoryGirl.create(:student)

      post :create, team_member_invite: {
        invitee_email: existing.email,
        team_id: student.team_id,
      }

      expect(invite.invitee).to eq(existing)
    end
  end
end
