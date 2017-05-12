require 'rails_helper'

RSpec.feature "Judges who score at RPEs are invited to virtual judge" do
  scenario "Virtual judge notices no difference" do
    vjudge = FactoryGirl.create(:judge, full_access: true)
    FactoryGirl.create(:team)
    sign_in(vjudge)

    puts page.body
    within("#virtual-scores") do
      expect(page).to have_link(
        "Start a new score now",
        href: new_judge_submission_score_path(event_type: :virtual)
      )
    end
  end

  scenario "Live judge sees the invitation" do
    judge = FactoryGirl.create(:judge, full_access: true)
    rpe = FactoryGirl.create(:rpe)
    sub = FactoryGirl.create(:team_submission)
    team = FactoryGirl.create(:team, team_submissions: [sub])

    rpe.teams << team
    rpe.save

    judge.regional_pitch_events << rpe
    judge.save

    expect(rpe.reload.teams.count).to eq(1)
    expect(rpe.reload.judges.count).to eq(1)

    sign_in(judge)

    within("#scores") do
      expect(page).to have_content("Please complete your Live Event scores")
    end
  end

  scenario "Live judge finishes their live event scores" do
    judge = FactoryGirl.create(:judge, full_access: true)
    rpe = FactoryGirl.create(:rpe)
    sub = FactoryGirl.create(:team_submission)
    team = FactoryGirl.create(:team, team_submissions: [sub])

    rpe.teams << team
    judge.regional_pitch_events << rpe

    expect(rpe.reload.teams.count).to eq(1)
    expect(rpe.reload.judges.count).to eq(1)

    judge.submission_scores.create!({ team_submission: sub, completed_at: Time.current })

    sign_in(judge)

    within("#scores") do
      expect(page).to have_content("You're invited to keep judging virtually")
    end
  end
end
