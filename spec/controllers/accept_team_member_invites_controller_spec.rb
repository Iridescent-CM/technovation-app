require "rails_helper"

RSpec.describe AcceptTeamMemberInvitesController do
  describe "GET #show" do
    let(:invite) { FactoryGirl.create(:team_member_invite) }


    it "accepts the team member invite" do
      get :show, id: invite.invite_token
      expect(invite.reload).to be_accepted
    end

    it "redirects to student signup with the email set" do
      expect(get :show, id: invite.invite_token).to redirect_to student_signup_path(email: invite.invitee_email)
    end
  end
end
