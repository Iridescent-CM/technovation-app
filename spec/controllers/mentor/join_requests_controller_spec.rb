require "rails_helper"

RSpec.describe Mentor::JoinRequestsController do
  describe "POST #new" do
    let(:team) { FactoryBot.create(:team, members_count: 2) }
    let(:mentor) { FactoryBot.create(:mentor) }

    before do
      sign_in(mentor)
    end

    it "redirects and displays alert if judging is enabled or between rounds" do
      SeasonToggles.judging_round = :qf

      post :new, params: { team_id: team.id }

      expect(response).to redirect_to mentor_team_path(team)
      expect(flash[:alert]).to eq(
        "Sorry, but team invitations are currently disabled because judging has already begun."
      )
    end
  end

  describe "POST #create" do
    let(:team) { FactoryBot.create(:team, members_count: 2) }
    let(:mentor) { FactoryBot.create(:mentor) }

    before do
      sign_in(mentor)
      post :create, params: { team_id: team.id }
    end

    before(:each) do
      SeasonToggles.judging_round = :off
    end

    it "redirects gracefully on dupe" do
      join_request = JoinRequest.last

      expect {
        post :create, params: { team_id: team.id }
      }.not_to change { JoinRequest.count }

      expect(response).to redirect_to(mentor_join_request_path(join_request))
    end

    it "sends the correct email to all members" do
      mails = ActionMailer::Base.deliveries.last(2)

      expect(mails.flat_map(&:to)).to match_array(team.students.map(&:email))

      expect(mails.map(&:subject).sample).to eq(
        "A mentor has asked to join your team!"
      )

      bodies = mails.map(&:body)

      expect(bodies.sample.to_s).to include(
        "#{mentor.first_name} has asked to join your Technovation team as a mentor"
      )

      expect(bodies.sample.to_s).to include("Review This Request")

      url = student_join_request_url(JoinRequest.last,
        host: ENV["HOST_DOMAIN"],
        port: ENV["HOST_DOMAIN"].split(":")[1]
      )

      expect(bodies.sample.to_s).to include("href=\"#{url}")
    end

    it "redirects and displays alert if judging is enabled or between rounds" do
      SeasonToggles.judging_round = :qf

      post :create, params: { team_id: team.id }

      expect(response).to redirect_to mentor_team_path(team)
      expect(flash[:alert]).to eq(
        "Sorry, but team invitations are currently disabled because judging has already begun."
      )
    end
  end

  describe "POST #show" do
    let(:team) { FactoryBot.create(:team, :with_mentor, members_count: 2) }
    let(:student) { FactoryBot.create(:student) }
    let(:join_request) {
      FactoryBot.create(
        :join_request,
        team: team,
        requestor: student
      )
    }

    before do
      sign_in(team.mentors.sample)
    end

    it "redirects and displays alert if judging is enabled or between rounds" do
      SeasonToggles.judging_round = :qf

      post :show, params: { id: join_request.review_token }

      expect(response).to redirect_to mentor_team_path(
        team,
        anchor: join_request.requestor_scope_name.pluralize
      )

      expect(flash[:alert]).to eq(
        "Sorry, but team invitations are currently disabled because judging has already begun."
      )
    end
  end

  describe "PUT #update" do
    let(:team) { FactoryBot.create(:team, :with_mentor, members_count: 2) }
    let(:student) { FactoryBot.create(:student) }
    let(:join_request) {
      FactoryBot.create(
        :join_request,
        team: team,
        requestor: student
      )
    }

    before do
      sign_in(team.mentors.sample)
      request.env["HTTP_REFERER"] = "/somewhere"
    end

    context "judging is enabled or between judging rounds" do
      before(:each) do
        SeasonToggles.judging_round = :qf
      end

      it "redirects and displays alert if approved" do
        put :update, params: {
          id: join_request.review_token,
          join_request: { status: :approved },
        }

        expect(response).to redirect_to mentor_team_path(
          team,
          anchor: join_request.requestor_scope_name.pluralize
        )

        expect(flash[:alert]).to eq(
          "Sorry, but team invitations are currently disabled because judging has already begun."
        )
      end

      it "redirects and displays alert if denied" do
        put :update, params: {
          id: join_request.review_token,
          join_request: { status: :declined },
        }

        expect(response).to redirect_to mentor_team_path(
          team,
          anchor: join_request.requestor_scope_name.pluralize
        )

        expect(flash[:alert]).to eq(
          "Sorry, but team invitations are currently disabled because judging has already begun."
        )
      end
    end
  end
end
