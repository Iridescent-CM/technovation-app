require "rails_helper"

RSpec.describe RegionalPitchEvent do
  describe "regioning" do
    it "works with primary region searches" do
      ra = FactoryBot.create(:ambassador, :chicago)

      chi = FactoryBot.create(:event, :chicago)
      FactoryBot.create(:event, :los_angeles)

      expect(RegionalPitchEvent.in_region(ra)).to contain_exactly(chi)
    end

    it "works with secondary region searches" do
      FactoryBot.create(:event, :brazil)

      la = FactoryBot.create(:event, :los_angeles)
      chi = FactoryBot.create(:event, :chicago)
      ra = FactoryBot.create(:ambassador, :chicago,
        secondary_regions: ["CA, US"])

      expect(RegionalPitchEvent.in_region(ra)).to contain_exactly(chi, la)
    end
  end

  it "removes incompatible division teams when trying to add" do
    team = FactoryBot.create(:team, :junior)
    rpe = FactoryBot.create(:event, :senior)

    expect {
      AddTeamToRegionalEvent.(rpe, team)
    }.to raise_error(AddTeamToRegionalEvent::IncompatibleDivisionError)

    expect(rpe.reload.teams).to be_empty
  end

  it "updates submission average scores if unofficial is toggled" do
    team = FactoryBot.create(:team, :senior)
    sub = FactoryBot.create(:submission, :complete, team: team)

    live_judge = FactoryBot.create(:judge_profile)
    virtual_judge = FactoryBot.create(:judge_profile)

    rpe = FactoryBot.create(:event, :senior)

    expect {
      AddTeamToRegionalEvent.(rpe, team)
    }.to change { rpe.reload.teams_count }.from(0).to(1)

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
