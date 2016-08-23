require "rails_helper"

RSpec.describe TeamMemberInvitesController do
  describe "PUT #update" do
    it "accepts the team member invite" do
      student = FactoryGirl.create(:student)
      invite = FactoryGirl.create(:team_member_invite, invitee: student)

      sign_in(student)
      put :update, id: invite.invite_token, team_member_invite: { status: :accepted }
      expect(invite.reload).to be_accepted
    end

    it "redirects to the student team page when the student account exists" do
      student = FactoryGirl.create(:student)
      invite = FactoryGirl.create(:team_member_invite, invitee_email: student.email)

      put :update, id: invite.invite_token, team_member_invite: { status: :accepted }

      expect(response).to redirect_to student_team_path(invite.team)
    end

    it "shows a friendly message if they are already on a team and try to accept" do
      team = FactoryGirl.create(:team)
      student = FactoryGirl.create(:student)
      invite = FactoryGirl.create(:team_member_invite, invitee_email: student.email)

      team.add_student(student)

      put :update, id: invite.invite_token, team_member_invite: { status: :accepted }

      expect(response).to redirect_to student_dashboard_path
      expect(flash[:alert]).to eq("You are already on a team, so you cannot accept that invite.")
      expect(invite.reload).to be_rejected
    end
  end
end
