require "rails_helper"

RSpec.describe Student::TeamsController do
  describe 'POST #create' do
    it "creates teams for students not on a team" do
      student = FactoryGirl.create(:student)
      sign_in(student)

      expect {
        post :create, params: {
          team: {
            name: "Girl Power",
            description: "We are a great team",
          }
        }
      }.to change { Team.count }.from(0).to 1

      expect(student.team).to eq(Team.last)
      expect(student.team.seasons).to eq([Season.current])
    end

    it "does not create teams for students already on a team" do
      student = FactoryGirl.create(:student, :on_team)
      sign_in(student)

      expect {
        post :create, params: {
          team: {
            name: "Girl Power",
            description: "We are a great team",
          }
        }
      }.not_to change { Team.count }

      expect(flash[:alert]).to eq(
        "You cannot create a new team if you are already on a team"
      )
    end

    it "declines any pending invites" do
      student = FactoryGirl.create(:student)
      invite = FactoryGirl.create(
        :team_member_invite,
        invitee_email: student.email
      )

      sign_in(student)
      post :create, params: {
        team: {
          name: "Girl Power",
          description: "We are a great team",
        }
      }

      expect(invite.reload).to be_declined
    end

    it "deletes any pending join requests" do
      student = FactoryGirl.create(:student)
      join_request = FactoryGirl.create(:join_request, requestor: student)

      sign_in(student)
      post :create, params: {
        team: {
          name: "Girl Power",
          description: "We are a great team",
        }
      }

      expect {
        join_request.reload
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "GET #new" do
    it "doesn't allow a student on a team to visit" do
      student = FactoryGirl.create(:student, :on_team)
      sign_in(student)

      get :new
      expect(flash[:alert]).to eq(
        "You cannot create a new team if you are already on a team"
      )
    end
  end
end
