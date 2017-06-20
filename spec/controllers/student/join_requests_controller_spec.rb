require "rails_helper"

RSpec.describe Student::JoinRequestsController do
  describe "POST #create" do
    it "emails all members" do
      team = FactoryGirl.create(:team, members_count: 0)
      student = FactoryGirl.create(:student)
      mentor = FactoryGirl.create(:mentor)

      TeamRosterManaging.add(team, :mentor, mentor)

      sign_in(student)
      request.env["HTTP_REFERER"] = "/somewhere"
      post :create, params: { team_id: team.id }

      mail = ActionMailer::Base.deliveries.last
      expect(mail).to be_present, "no join request email sent"
      expect(mail.to).to eq([mentor.email])

      url = mentor_team_url(team,
                            host: ENV["HOST_DOMAIN"],
                            port: ENV["HOST_DOMAIN"].split(":")[1])

      expect(mail.body.to_s).to include("href=\"#{url}\"")
    end
  end

  describe "PUT #update" do
    let(:team) { FactoryGirl.create(:team, members_count: 2) }
    let(:mentor) { FactoryGirl.create(:mentor) }
    let(:join_request) { FactoryGirl.create(:join_request,
                                            joinable: team,
                                            requestor: mentor) }

    before do
      sign_in(team.students.sample)
      request.env["HTTP_REFERER"] = "/somewhere"
    end

    context "accepting the request" do
      before do
        ActionMailer::Base.deliveries.clear
        put :update, params: { id: join_request.id, status: :approved }
      end

      it "adds the mentor to the team" do
        expect(mentor.teams).to include(team)
      end

      it "emails the mentor acceptance email" do
        expect(ActionMailer::Base.deliveries.count).not_to be_zero, "No join request approval email was sent"
        mail = ActionMailer::Base.deliveries.last
        expect(mail.to).to eq([JoinRequest.last.requestor_email])
        expect(mail.subject).to eq("Your request to mentor #{team.name} was accepted!")
        expect(mail.body.to_s).to include("#{team.name} accepted your request to be their mentor!")

        url = mentor_team_url(team,
                              host: ENV["HOST_DOMAIN"],
                              port: ENV["HOST_DOMAIN"].split(":")[1])

        expect(mail.body.to_s).to include("href=\"#{url}\"")
      end
    end

    context "declining the request" do
      before do
        ActionMailer::Base.deliveries.clear
        put :update, params: { id: join_request.id, status: :declined }
      end

      it "does not add the mentor to the team" do
        expect(mentor.teams).not_to include(team)
      end

      it "emails the mentor declined email" do
        expect(ActionMailer::Base.deliveries.count).not_to be_zero, "No join request decline email was sent"
        mail = ActionMailer::Base.deliveries.last
        expect(mail.to).to eq([JoinRequest.last.requestor_email])
        expect(mail.subject).to eq("Your request to mentor #{team.name} was declined")
        expect(mail.body.to_s).to include("#{team.name} has declined your request to be their mentor.")
      end
    end
  end
end
