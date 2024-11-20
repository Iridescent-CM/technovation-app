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
        team_member_invite: {status: :pending}
      }

      expect(response).to redirect_to mentor_dashboard_path
      expect(flash[:alert]).to eq(
        "Sorry, but team invitations are currently disabled because judging has already begun."
      )
      expect(invite.reload).to be_pending
    end

    it "redirects to dashboard and shows a friendly message if between judging rounds" do
      SeasonToggles.judging_round = :between

      get :show, params: {
        id: invite.invite_token,
        team_member_invite: {status: :pending}
      }

      expect(response).to redirect_to mentor_dashboard_path
      expect(flash[:alert]).to eq(
        "Sorry, but team invitations are currently disabled because judging has already begun."
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
        team_member_invite: {status: :accepted}
      }

      expect(invite.reload).to be_accepted
    end

    it "assigns the mentor to each of the student's chapter on the team" do
      put :update, params: {
        id: invite.invite_token,
        team_member_invite: {status: :accepted}
      }

      mentor_chapter_assignments = mentor.account.chapter_assignments.map do |assignment|
        assignment.chapter
      end

      invite.team.students.each do |student|
        expect(mentor_chapter_assignments).to include(student.account.current_chapter)
      end
    end

    it "redirects to the mentor team page" do
      put :update, params: {
        id: invite.invite_token,
        team_member_invite: {status: :accepted}
      }

      expect(response).to redirect_to mentor_team_path(invite.team)
    end

    it "shows a friendly message if accepting, but judging is enabled" do
      SeasonToggles.judging_round = :qf

      put :update, params: {
        id: invite.invite_token,
        team_member_invite: {status: :accepted}
      }

      expect(response).to redirect_to mentor_dashboard_path
      expect(flash[:alert]).to eq(
        "Sorry, but team invitations are currently disabled because judging has already begun."
      )
      expect(invite.reload).to be_pending
    end

    it "shows a friendly message if accepting, but between judging rounds" do
      SeasonToggles.judging_round = :between

      put :update, params: {
        id: invite.invite_token,
        team_member_invite: {status: :accepted}
      }

      expect(response).to redirect_to mentor_dashboard_path
      expect(flash[:alert]).to eq(
        "Sorry, but team invitations are currently disabled because judging has already begun."
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
        "Sorry, but team invitations are currently disabled because judging has already begun."
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
        "Sorry, but team invitations are currently disabled because judging has already begun."
      )
      expect(invite.reload).to be_pending
    end
  end

  describe "mentor chapter assignments" do
    context "when two students from the same chapter are on a team" do
      let(:team) { FactoryBot.create(:team) }
      let(:mentor) { FactoryBot.create(:mentor, :onboarded) }
      let(:chapter) { FactoryBot.create(:chapter) }
      let(:student1) { FactoryBot.create(:student, :not_assigned_to_chapter) }
      let(:student2) { FactoryBot.create(:student, :not_assigned_to_chapter) }
      let!(:invite) { FactoryBot.create(:team_member_invite, invitee: mentor) }

      before do
        student1.chapter_assignments.create(
          chapter: chapter,
          account: student1.account,
          season: Season.current.year
        )

        student2.chapter_assignments.create(
          chapter: chapter,
          account: student2.account,
          season: Season.current.year
        )

        team.students << student1
        team.students << student2
        team.save

        invite.team = team
        invite.save
      end

      context "when the mentor invite request for this team is accepted" do
        before do
          sign_in(mentor)

          put :update, params: {
            id: invite.invite_token,
            team_member_invite: {status: :accepted}
          }
        end

        it "creates one non-primary chapter assignment (since both students belong to the same chapter)" do
          expect(mentor.account.chapter_assignments.where(chapter: chapter, primary: false).count).to eq(1)
        end

        it "assigns the mentor to the student's chapter" do
          mentor_chapter_assignments = mentor.account.chapter_assignments.map do |assignment|
            assignment.chapter
          end

          expect(mentor_chapter_assignments).to include(student1.account.current_chapter)
        end
      end
    end
  end
end
