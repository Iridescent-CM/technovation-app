require "rails_helper"

RSpec.describe TeamMemberInviteAcceptancesController do
  describe "GET #show" do
    let(:invite) { FactoryGirl.create(:team_member_invite) }


    it "accepts the team member invite" do
      get :show, id: invite.invite_token
      expect(invite.reload).to be_accepted
    end

    it "redirects to student signup with the email set" do
      expect(get :show, id: invite.invite_token).to redirect_to student_signup_path(email: invite.invitee_email)
    end

    it "redirects to the team page when the student exists" do
      student = FactoryGirl.create(:student, email: invite.invitee_email)
      expect(get :show, id: invite.invite_token).to redirect_to student_team_path(student.reload.team)
    end

    it "redirects to the team page when the mentor exists" do
      mentor = FactoryGirl.create(:mentor, email: invite.invitee_email)
      expect(get :show, id: invite.invite_token).to redirect_to mentor_team_path(mentor.reload.teams.last)
    end
  end
end
