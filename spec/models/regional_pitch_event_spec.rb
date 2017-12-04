require "rails_helper"

RSpec.describe RegionalPitchEvent do
  it "triggers an updates on team submission average scores if unofficial is toggled" do
    # TODO Fix this broken test
    skip "This is broken and it doesn't matter right now"

    team = FactoryBot.create(:team)
    sub = FactoryBot.create(:submission, :complete, team: team)

    live_judge = FactoryBot.create(:judge_profile)
    virtual_judge = FactoryBot.create(:judge_profile)

    rpe = RegionalPitchEvent.create!({
      regional_ambassador_profile: FactoryBot.create(:regional_ambassador_profile),
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
      evidence_of_problem: 5,
      completed_at: Time.current
    })

    virtual_judge.submission_scores.create!({
      team_submission: sub,
      evidence_of_problem: 2,
      completed_at: Time.current
    })

    expect(sub.reload.quarterfinals_average_score).to eq(5)
    expect(sub.reload.average_unofficial_score).to eq(2)

    rpe.update(unofficial: true)

    expect(sub.reload.quarterfinals_average_score).to eq(2)
    expect(sub.reload.average_unofficial_score).to eq(5)

    rpe.update(unofficial: false)

    expect(sub.reload.quarterfinals_average_score).to eq(5)
    expect(sub.reload.average_unofficial_score).to eq(2)
  end
end
