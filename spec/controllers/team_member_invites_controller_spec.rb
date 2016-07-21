require "rails_helper"

RSpec.describe TeamMemberInvitesController do
  describe "PUT #update" do
    it "accepts the team member invite" do
      invite = FactoryGirl.create(:team_member_invite)
      put :update, id: invite.invite_token
      expect(invite.reload).to be_accepted
    end

    it "redirects to student signup with the email set" do
      invite = FactoryGirl.create(:team_member_invite)

      expect(put :update, id: invite.invite_token)
        .to redirect_to student_signup_path(email: invite.invitee_email)
    end

    it "redirects to the student team page when the student account exists" do
      student = FactoryGirl.create(:student)
      invite = FactoryGirl.create(:team_member_invite, invitee_email: student.email)
      expect(put :update, id: invite.invite_token).to redirect_to student_team_path(invite.team)
    end
  end
end
