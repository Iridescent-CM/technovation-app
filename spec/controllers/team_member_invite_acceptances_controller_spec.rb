require "rails_helper"

RSpec.describe TeamMemberInviteAcceptancesController do
  describe "GET #show" do
    it "accepts the team member invite" do
      invite = FactoryGirl.create(:team_member_invite)
      get :show, id: invite.invite_token
      expect(invite.reload).to be_accepted
    end

    it "redirects to student signup with the email set" do
      invite = FactoryGirl.create(:team_member_invite)

      expect(get :show, id: invite.invite_token)
        .to redirect_to student_signup_path(email: invite.invitee_email)
    end

    it "redirects to the team page when the account exists" do
      student = FactoryGirl.create(:student)
      invite = FactoryGirl.create(:team_member_invite, invitee_email: student.email)
      expect(get :show, id: invite.invite_token).to redirect_to student_team_path(student.reload.team)
    end
  end
end
