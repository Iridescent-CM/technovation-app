require "rails_helper"

RSpec.describe Student::JoinRequestsController do
  describe "POST #new" do
    let(:team) { FactoryBot.create(:team, members_count: 2) }
    let(:student) { FactoryBot.create(:student) }

    before do
      sign_in(student)
    end

    it "redirects and displays alert if judging is enabled or between rounds" do
      SeasonToggles.judging_round = :qf

      post :new, params: {team_id: team.id}

      expect(response).to redirect_to student_team_path(team)
      expect(flash[:alert]).to eq(
        "Sorry, but team invitations are currently disabled because judging has already begun."
      )
    end
  end

  describe "POST #show" do
    let(:team) { FactoryBot.create(:team, members_count: 2) }
    let(:mentor) { FactoryBot.create(:mentor, :onboarded) }
    let(:join_request) {
      FactoryBot.create(
        :join_request,
        team: team,
        requestor: mentor
      )
    }

    before do
      sign_in(team.students.sample)
    end

    it "redirects and displays alert if judging is enabled or between rounds" do
      SeasonToggles.judging_round = :qf

      post :show, params: {id: join_request.review_token}

      expect(response).to redirect_to student_team_path(
        team,
        anchor: join_request.requestor_scope_name.pluralize
      )

      expect(flash[:alert]).to eq(
        "Sorry, but team invitations are currently disabled because judging has already begun."
      )
    end
  end

  describe "POST #create" do
    let(:team) { FactoryBot.create(:team) }
    let(:student) { FactoryBot.create(:student) }
    let(:mentor) { FactoryBot.create(:mentor, :onboarded) }

    before do
      Timecop.freeze(ImportantDates.quarterfinals_judging_begins - 1.day)
      TeamRosterManaging.add(team, mentor)
      sign_in(student)
      request.env["HTTP_REFERER"] = "/somewhere"
    end

    after do
      Timecop.return
    end

    before(:each) do
      SeasonToggles.judging_round = :off
    end

    it "emails all members" do
      post :create, params: {team_id: team.id}

      mail = ActionMailer::Base.deliveries.last
      expect(mail).to be_present, "no join request email sent"
      expect(mail.to).to eq([mentor.email])

      url = mentor_join_request_url(
        JoinRequest.last,
        mailer_token: mentor.mailer_token,
        host: ENV["HOST_DOMAIN"],
        port: ENV["HOST_DOMAIN"].split(":")[1]
      )

      expect(mail.body.to_s).to include("href=\"#{url}")
    end

    it "redirects gracefully on dupe" do
      expect {
        post :create, params: {team_id: team.id}
        post :create, params: {team_id: team.id}
      }.to change { JoinRequest.count }.by(1)

      expect(response).to redirect_to(student_dashboard_path(anchor: "/find-team"))
    end

    it "redirects and displays alert if judging is enabled or between rounds" do
      SeasonToggles.judging_round = :qf

      post :create, params: {team_id: team.id}

      expect(response).to redirect_to student_team_path(team)
      expect(flash[:alert]).to eq(
        "Sorry, but team invitations are currently disabled because judging has already begun."
      )
    end
  end

  describe "PUT #update" do
    let(:team) { FactoryBot.create(:team, members_count: 2) }
    let(:mentor) { FactoryBot.create(:mentor, :onboarded) }
    let(:join_request) {
      FactoryBot.create(
        :join_request,
        team: team,
        requestor: mentor
      )
    }

    before do
      Timecop.freeze(ImportantDates.quarterfinals_judging_begins - 1.day)
      sign_in(team.students.sample)
      request.env["HTTP_REFERER"] = "/somewhere"
    end

    after do
      Timecop.return
    end

    context "when the join request is accepted" do
      before do
        ActionMailer::Base.deliveries.clear

        put :update, params: {
          id: join_request.review_token,
          join_request: {status: :approved}
        }
      end

      it "adds the mentor to the team" do
        expect(mentor.teams).to include(team)
      end

      it "assigns the mentor to each of the student's chapter on the team" do
        mentor_chapter_assignments = mentor.account.chapter_assignments.map do |assignment|
          assignment.chapter
        end

        team.students.each do |student|
          expect(mentor_chapter_assignments).to include(student.account.current_chapter)
        end
      end

      it "emails the mentor acceptance email" do
        expect(ActionMailer::Base.deliveries.count).not_to be_zero,
          "No join request approval email was sent"

        mail = ActionMailer::Base.deliveries.last

        expect(mail.to).to eq([JoinRequest.last.requestor_email])

        expect(mail.subject).to eq(
          "Your request to mentor #{team.name} was accepted!"
        )

        expect(mail.body.to_s).to include(
          "#{team.name} accepted your request to be their mentor!"
        )

        url = mentor_team_url(
          team,
          mailer_token: mentor.mailer_token,
          host: ENV["HOST_DOMAIN"],
          port: ENV["HOST_DOMAIN"].split(":")[1]
        )

        expect(mail.body.to_s).to include("href=\"#{url}\"")
      end
    end

    context "when the join request is declined" do
      before do
        ActionMailer::Base.deliveries.clear
        put :update, params: {
          id: join_request.review_token,
          join_request: {status: :declined}
        }
      end

      it "does not add the mentor to the team" do
        expect(mentor.teams).not_to include(team)
      end

      it "emails the mentor declined email" do
        expect(ActionMailer::Base.deliveries.count).not_to be_zero,
          "No join request decline email was sent"

        mail = ActionMailer::Base.deliveries.last

        expect(mail.to).to eq([JoinRequest.last.requestor_email])

        expect(mail.subject).to eq(
          "Your request to mentor #{team.name} was declined"
        )

        expect(mail.body.to_s).to include(
          "#{team.name} has declined your request to be their mentor."
        )
      end
    end

    context "judging is enabled or between judging rounds" do
      before(:each) do
        SeasonToggles.judging_round = :qf
      end

      it "redirects and displays alert if approved" do
        put :update, params: {
          id: join_request.review_token,
          join_request: {status: :approved}
        }

        expect(response).to redirect_to student_team_path(
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
          join_request: {status: :declined}
        }

        expect(response).to redirect_to student_team_path(
          team,
          anchor: join_request.requestor_scope_name.pluralize
        )

        expect(flash[:alert]).to eq(
          "Sorry, but team invitations are currently disabled because judging has already begun."
        )
      end
    end
  end

  describe "mentor chapter assignments" do
    context "when two students from the same chapter are on a team" do
      let(:team) { FactoryBot.create(:team) }
      let(:mentor) { FactoryBot.create(:mentor, :onboarded) }
      let(:chapter) { FactoryBot.create(:chapter) }
      let(:student1) { FactoryBot.create(:student, :not_assigned_to_chapter) }
      let(:student2) { FactoryBot.create(:student, :not_assigned_to_chapter) }
      let(:join_request) {
        FactoryBot.create(
          :join_request,
          team: team,
          requestor: mentor
        )
      }

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
      end

      before do
        sign_in(student1)
      end

      context "when the mentor join request for the team is accepted" do
        before do
          put :update, params: {
            id: join_request.review_token,
            join_request: {status: :approved}
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
