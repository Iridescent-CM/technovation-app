require "rails_helper"

RSpec.feature "RA prints event scores" do
  scenario "assigned judges and teams are grouped together" do
    ra = FactoryBot.create(:ra, :approved)
    event = ra.regional_pitch_events.create!(FactoryBot.attributes_for(:event))

    judge_a = FactoryBot.create(:judge, first_name: "Alvin")
    judge_b = FactoryBot.create(:judge, first_name: "Theodore")
    judge_c = FactoryBot.create(:judge, first_name: "Simon")

    team_a = FactoryBot.create(:team, :live_event_eligible, name: "Ducktales")
    team_b = FactoryBot.create(:team, :live_event_eligible, name: "Darkwing")
    team_c = FactoryBot.create(:team, :live_event_eligible, name: "Donald")

    event.judges << judge_a
    event.judges << judge_b
    event.judges << judge_c

    event.teams << team_a
    event.teams << team_b
    event.teams << team_c

    judge_a.assigned_teams << team_a
    judge_a.assigned_teams << team_b

    judge_c.assigned_teams << team_c

    judge_b.assigned_teams << team_b
    judge_b.assigned_teams << team_a

    FactoryBot.create(
      :submission_score,
      :complete,
      judge_profile: judge_a,
      team_submission: team_a.submission
    )

    FactoryBot.create(
      :submission_score,
      :complete,
      judge_profile: judge_a,
      team_submission: team_b.submission
    )

    FactoryBot.create(
      :submission_score,
      :complete,
      judge_profile: judge_b,
      team_submission: team_b.submission
    )

    # INCOMPLETE SCORE
    FactoryBot.create(
      :submission_score,
      judge_profile: judge_b,
      team_submission: team_a.submission
    )

    FactoryBot.create(
      :submission_score,
      :complete,
      judge_profile: judge_c,
      team_submission: team_c.submission
    )

    sign_in(ra)
    visit regional_ambassador_printable_score_path(event)

    expect(page).to have_content("#{judge_a.name}\n#{team_a.name}")
    expect(page).to have_content("#{judge_b.name}\n#{team_a.name}")

    expect(page).to have_css(".page", count: 10)
    expect(page).to have_css(".page-comments", count: 5)
    expect(page).to have_css(".cover-page", count: 4)
    expect(page).to have_css(".cover-page--blank", count: 2)
  end
end