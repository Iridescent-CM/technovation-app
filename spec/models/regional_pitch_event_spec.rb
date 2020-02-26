require "rails_helper"

RSpec.describe RegionalPitchEvent do
  describe ".officiality" do
    let(:finalization_point) { ImportantDates.rpe_officiality_finalized }
    let(:official_rpe) { FactoryBot.create(:rpe, unofficial: false) }
    let(:unofficial_rpe) { FactoryBot.create(:rpe, unofficial: true) }

    it "is pending before finalization point" do
      [
        finalization_point - 1.day,
        finalization_point - 1.minute,
      ].each do |point|
        Timecop.freeze(point) do
          expect(official_rpe.officiality).to be :pending
          expect(unofficial_rpe.officiality).to be :pending
        end
      end
    end

    it "is appropriate status on or after finalization point" do
      [
        finalization_point,
        finalization_point + 1.minute,
        finalization_point + 1.day,
      ].each do |point|
        Timecop.freeze(point) do
          expect(official_rpe.officiality).to be :official
          expect(unofficial_rpe.officiality).to be :unofficial
        end
      end
    end

    it "is independent of user time zone" do
      Timecop.freeze(finalization_point) do
        west_zone = Time.find_zone('International Date Line West')
        app_zone = Time.zone
        east_zone = Time.find_zone('Samoa')

        expect(west_zone).to be < app_zone
        expect(app_zone).to be < east_zone

        west = Time.use_zone('International Date Line West') { official_rpe.officiality }
        east = Time.use_zone('Samoa') { official_rpe.officiality }

        expect(west).to eq(east)
      end
    end
  end

  describe "#to_list_json" do
    let(:rpe) { FactoryBot.create(:rpe) }
    let(:json) { rpe.to_list_json }

    it "includes attributes" do
      expect(json[:officiality]).to eq(rpe.officiality)
    end
  end

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

  it "prevents teams from being added to event when event is at team capacity" do
    team = FactoryBot.create(:team, :junior)
    rpe = FactoryBot.create(:event, :junior, :junior_at_team_capacity)

    expect {
      AddTeamToRegionalEvent.(rpe, team)
    }.to raise_error(AddTeamToRegionalEvent::EventAtTeamCapacityError)

    expect(rpe.teams.length).to eq(1)
  end

  it "updates quarterfinals submission average scores if unofficial is toggled" do
    SeasonToggles.set_judging_round(:qf)

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
      ideation_2: 5,
      completed_at: Time.current
    })

    virtual_judge.submission_scores.create!({
      team_submission: sub,
      ideation_2: 2,
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

    SeasonToggles.clear_judging_round
  end

  it "updates semifinals submission average scores" do
    SeasonToggles.set_judging_round(:sf)

    team = FactoryBot.create(:team, :senior)
    sub = FactoryBot.create(:submission, :complete, team: team)

    virtual_judge = FactoryBot.create(:judge_profile)

    virtual_judge.submission_scores.create!({
      team_submission: sub,
      ideation_2: 2,
      completed_at: Time.current,
      round: SeasonToggles.current_judging_round(full_name: true)
    })

    expect(sub.reload.semifinals_average_score).to eq(2)

    SeasonToggles.clear_judging_round
  end
end
