require "rails_helper"

RSpec.describe FindEligibleSubmissionId do
  it "does not choose incomplete submission" do
    judge = FactoryGirl.create(:judge)
    team = FactoryGirl.create(:team)
    FactoryGirl.create(:submission, team: team)

    expect(FindEligibleSubmissionId.(judge)).to be_nil
  end

  it " chooses submissions with fewest scores" do
    judge1 = FactoryGirl.create(:judge)
    team1 = FactoryGirl.create(:team)
    sub_with_score = FactoryGirl.create(:submission, :complete, team: team1)
    SubmissionScore.create!(
      judge_profile_id: judge1.id,
      team_submission_id: sub_with_score.id,
    )

    judge2 = FactoryGirl.create(:judge)
    team2 = FactoryGirl.create(:team)
    sub_without_score = FactoryGirl.create(:submission, :complete, team: team2)

    expect(FindEligibleSubmissionId.(judge2)).to eq(sub_without_score.id)
  end

  it "does not reselect previously judged submission" do
    judge = FactoryGirl.create(:judge)
    team = FactoryGirl.create(:team)
    sub = TeamSubmission.create!({
      integrity_affirmed: true,
      team: team,
    })
    score = SubmissionScore.create!(
      judge_profile_id: judge.id,
      team_submission_id: sub.id,
    )
    score.complete!

    expect(FindEligibleSubmissionId.(judge)).to be_nil
  end

  it "selects submission for an unofficial regional pitch event" do
    judge = FactoryGirl.create(:judge)
    team = FactoryGirl.create(:team)

    team.regional_pitch_events << RegionalPitchEvent.create!({
      regional_ambassador_profile: FactoryGirl.create(:regional_ambassador_profile),
      name: "RPE",
      starts_at: Date.today,
      ends_at: Date.today + 1.day,
      division_ids: Division.senior.id,
      city: "City",
      venue_address: "123 Street St.",
      unofficial: true
    })

    sub = FactoryGirl.create(:submission, :complete, team: team)

    expect(FindEligibleSubmissionId.(judge)).to eq(sub.id)
  end

  it "does not select submission for an official regional pitch event" do
    judge = FactoryGirl.create(:judge)
    team = FactoryGirl.create(:team)
    team.regional_pitch_events << RegionalPitchEvent.create!({
      regional_ambassador_profile: FactoryGirl.create(:regional_ambassador_profile),
      name: "RPE",
      starts_at: Date.today,
      ends_at: Date.today + 1.day,
      division_ids: Division.senior.id,
      city: "City",
      venue_address: "123 Street St.",
      unofficial: false
    })

    TeamSubmission.create!({
      integrity_affirmed: true,
      team: team,
    })

    expect(FindEligibleSubmissionId.(judge)).to be_nil
  end

  context "judge without team" do
    it "returns submission id" do
      judge = FactoryGirl.create(:judge)
      team = FactoryGirl.create(:team)
      sub = FactoryGirl.create(:submission, :complete, team: team)

      expect(FindEligibleSubmissionId.(judge)).to eq(sub.id)
    end
  end

  context "judge with team" do
    it "returns submission id from team in different region" do
      judge = FactoryGirl.create(:judge)
      judge.account.mentor_profile = FactoryGirl.create(:mentor)

      judges_team = FactoryGirl.create(:team, division: Division.senior)
      judge.teams << judges_team

      different_region_team = FactoryGirl.create(:team,
                                                 city: "Los Angeles",
                                                 state_province: "CA",
                                                 division: Division.senior)
      sub = FactoryGirl.create(:submission, :complete, team: different_region_team)

      expect(FindEligibleSubmissionId.(judge)).to eq(sub.id)
    end

    it "returns submission id from team in different division" do
      judge = FactoryGirl.create(:judge)
      judge.account.mentor_profile = FactoryGirl.create(:mentor)

      judges_team = FactoryGirl.create(:team, division: Division.senior)
      judge.teams << judges_team

      different_division_team = FactoryGirl.create(:team, division: Division.junior)
      sub = FactoryGirl.create(:submission, :complete, team: different_division_team)

      expect(FindEligibleSubmissionId.(judge)).to eq(sub.id)
    end

    it "does not return submission id from judge's team" do
      judge = FactoryGirl.create(:judge)
      judge.account.mentor_profile = FactoryGirl.create(:mentor)

      judges_team = FactoryGirl.create(:team)
      judge.teams << judges_team
      FactoryGirl.create(:submission, :complete, team: judges_team)

      expect(FindEligibleSubmissionId.(judge)).to be_nil
    end

    it "does not return submission id from team in same region and division" do
      judge = FactoryGirl.create(:judge)
      judge.account.mentor_profile = FactoryGirl.create(:mentor)

      judges_team = FactoryGirl.create(:team)
      judge.teams << judges_team

      same_region_division_team = FactoryGirl.create(:team)
      FactoryGirl.create(:submission, :complete, team: same_region_division_team)

      expect(FindEligibleSubmissionId.(judge)).to be_nil
    end
  end
end
