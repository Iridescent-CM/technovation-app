require "rails_helper"

RSpec.describe TeamMemberInvitesController do
  describe "PUT #update" do
    it "accepts the team member invite" do
      student = FactoryGirl.create(:student)
      invite = FactoryGirl.create(:team_member_invite, invitee: student)
      FactoryGirl.create(:team_member_invite, invitee: student)

      sign_in(student)
      put :update, id: invite.invite_token, team_member_invite: { status: :accepted }
      expect(invite.reload).to be_accepted
    end

    it "redirects to the student team page when the student account exists" do
      student = FactoryGirl.create(:student)
      invite = FactoryGirl.create(:team_member_invite, invitee_email: student.email)
      FactoryGirl.create(:team_member_invite, invitee: student)

      put :update, id: invite.invite_token, team_member_invite: { status: :accepted }

      expect(response).to redirect_to student_team_path(invite.team)
    end
  end
end
