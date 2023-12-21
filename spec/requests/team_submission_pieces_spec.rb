require "rails_helper"

RSpec.describe "GET /team_submission_pieces/:piece" do
  it "requires you to sign in" do
    get "/team_submission_pieces/app_name"
    expect(response).to redirect_to(signin_path)
  end

  it "redirects based on who signs in" do
    mentor = FactoryBot.create(:mentor, :onboarded)

    allow_any_instance_of(ApplicationController).to receive(
      :current_account
    ).and_return(mentor.account)

    get "/team_submission_pieces/app_name"
    expect(response).to redirect_to(new_mentor_team_submission_path)

    student = FactoryBot.create(:student)

    allow_any_instance_of(ApplicationController).to receive(
      :current_account
    ).and_return(student.account)

    get "/team_submission_pieces/app_name"
    expect(response).to redirect_to(new_student_team_submission_path)
  end

  it "redirects to editing existing submission pieces" do
    student = FactoryBot.create(:student, :on_team)
    submission = FactoryBot.create(:team_submission, team: student.team)

    allow_any_instance_of(ApplicationController).to receive(
      :current_account
    ).and_return(student.account)

    get "/team_submission_pieces/app_name"

    expect(response).to redirect_to(
      edit_student_team_submission_path(submission, piece: :app_name)
    )

    mentor = FactoryBot.create(:mentor, :onboarded, :on_team)
    submission = FactoryBot.create(
      :team_submission,
      team: mentor.teams.first
    )

    allow_any_instance_of(ApplicationController).to receive(
      :current_account
    ).and_return(mentor.account)

    get "/team_submission_pieces/app_name"

    expect(response).to redirect_to(
      edit_mentor_team_submission_path(submission, piece: :app_name)
    )
  end
end
