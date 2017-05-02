require "rails_helper"

RSpec.describe RegionalPitchEvent do
  it "triggers an updates on team submission average scores if unofficial is toggled" do
    team = FactoryGirl.create(:team)
    sub = FactoryGirl.create(:submission, :complete, team: team)

    live_judge = FactoryGirl.create(:judge_profile)
    virtual_judge = FactoryGirl.create(:judge_profile)

    rpe = RegionalPitchEvent.create!({
      name: "RPE",
      starts_at: Date.today,
      ends_at: Date.today + 1.day,
      division_ids: Division.senior.id,
      city: "City",
      venue_address: "123 Street St.",
    })

    team.regional_pitch_events << rpe
    live_judge.regional_pitch_events << rpe

    live_judge.submission_scores.create!({
      team_submission: sub,
      sdg_alignment: 5,
      completed_at: Time.current
    })

    virtual_judge.submission_scores.create!({
      team_submission: sub,
      sdg_alignment: 2,
      completed_at: Time.current
    })

    expect(sub.reload.average_score).to eq(5)
    expect(sub.reload.average_unofficial_score).to eq(2)

    rpe.update_attributes(unofficial: true)

    expect(sub.reload.average_score).to eq(2)
    expect(sub.reload.average_unofficial_score).to eq(5)

    rpe.update_attributes(unofficial: false)

    expect(sub.reload.average_score).to eq(5)
    expect(sub.reload.average_unofficial_score).to eq(2)
  end
end
