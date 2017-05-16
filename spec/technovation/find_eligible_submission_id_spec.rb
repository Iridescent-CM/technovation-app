require "rails_helper"

RSpec.describe FindEligibleSubmissionId do
  context "quarterfinals" do
    it "does not choose incomplete submission" do
      judge = FactoryGirl.create(:judge)
      team = FactoryGirl.create(:team)
      FactoryGirl.create(:submission, team: team)

      expect(FindEligibleSubmissionId.(judge)).to be_nil
    end

    it "chooses submissions with fewest scores" do
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
      sub = FactoryGirl.create(:submission, :complete, team: team)
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

    it "ignores unofficial live scores when selecting" do
      unofficial_rpe = RegionalPitchEvent.create!({
        regional_ambassador_profile: FactoryGirl.create(:regional_ambassador_profile),
        name: "RPE",
        starts_at: Date.today,
        ends_at: Date.today + 1.day,
        division_ids: Division.senior.id,
        city: "City",
        venue_address: "123 Street St.",
        unofficial: true
      })

      team1 = FactoryGirl.create(:team)
      team1.regional_pitch_events << unofficial_rpe
      sub_with_unofficial_scores = FactoryGirl.create(:submission, :complete, team: team1)

      team2 = FactoryGirl.create(:team)
      sub_with_official_score = FactoryGirl.create(:submission, :complete, team: team2)

      rpe_judge1 = FactoryGirl.create(:judge)
      rpe_judge1.regional_pitch_events << unofficial_rpe
      SubmissionScore.create!(
        judge_profile_id: rpe_judge1.id,
        team_submission_id: sub_with_unofficial_scores.id
      )

      rpe_judge2 = FactoryGirl.create(:judge)
      rpe_judge2.regional_pitch_events << unofficial_rpe
      SubmissionScore.create!(
        judge_profile_id: rpe_judge2.id,
        team_submission_id: sub_with_unofficial_scores.id
      )

      judge3 = FactoryGirl.create(:judge)
      SubmissionScore.create!(
        judge_profile_id: judge3.id,
        team_submission_id: sub_with_official_score.id
      )

      expect(FindEligibleSubmissionId.(FactoryGirl.create(:judge))).to eq(sub_with_unofficial_scores.id)
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

  context "semifinals" do

    before do
      ENV["JUDGING_ROUND"] = "SF"
    end

    let(:sf_rank) { TeamSubmission.contest_ranks[:semifinalist] }
    let(:qf_round) { SubmissionScore.rounds[:quarterfinals] }
    let(:sf_round) { SubmissionScore.rounds[:semifinals] }

    it "does not choose quarterfinalist submission" do
      judge = FactoryGirl.create(:judge)
      team = FactoryGirl.create(:team)
      FactoryGirl.create(:submission, :complete, team: team, contest_rank: TeamSubmission.contest_ranks[:quarterfinalist])

      expect(FindEligibleSubmissionId.(judge)).to be_nil
    end

    it "chooses semifinalist submission" do
      judge = FactoryGirl.create(:judge)
      team = FactoryGirl.create(:team)
      submission = FactoryGirl.create(:submission, :complete, team: team, contest_rank: sf_rank)

      expect(FindEligibleSubmissionId.(judge)).to eq(submission.id)
    end

    it "chooses submissions with fewest semifinals scores" do
      judge1 = FactoryGirl.create(:judge)
      team1 = FactoryGirl.create(:team)
      sub_with_sf_score = FactoryGirl.create(:submission, :complete, team: team1, contest_rank: sf_rank)
      SubmissionScore.create!(
        judge_profile_id: judge1.id,
        team_submission_id: sub_with_sf_score.id,
        round: SubmissionScore.rounds[:semifinals]
      )

      judge2 = FactoryGirl.create(:judge)
      team2 = FactoryGirl.create(:team)
      sub_without_sf_score = FactoryGirl.create(:submission, :complete, team: team2, contest_rank: sf_rank)
      SubmissionScore.create!(
        judge_profile_id: judge1.id,
        team_submission_id: sub_without_sf_score.id,
        round: qf_round
      )
      SubmissionScore.create!(
        judge_profile_id: FactoryGirl.create(:judge).id,
        team_submission_id: sub_without_sf_score.id,
        round: qf_round
      )

      expect(FindEligibleSubmissionId.(judge2)).to eq(sub_without_sf_score.id)
    end

    it "selects submission judged in quarterfinals" do
      judge = FactoryGirl.create(:judge)
      team = FactoryGirl.create(:team)
      sub = FactoryGirl.create(:submission, :complete, team: team, contest_rank: sf_rank)
      score = SubmissionScore.create!(
        judge_profile_id: judge.id,
        team_submission_id: sub.id,
        round: qf_round
      )
      score.complete!

      expect(FindEligibleSubmissionId.(judge)).to eq(sub.id)
    end

    it "does not select submission judged already in semifinals" do
      judge = FactoryGirl.create(:judge)
      team = FactoryGirl.create(:team)
      sub = FactoryGirl.create(:submission, :complete, team: team, contest_rank: sf_rank)
      score = SubmissionScore.create!(
        judge_profile_id: judge.id,
        team_submission_id: sub.id,
        round: sf_round
      )
      score.complete!

      expect(FindEligibleSubmissionId.(judge)).to be_nil
    end

    it "selects submission for an official regional pitch event" do
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

      sub = FactoryGirl.create(:submission, :complete, team: team, contest_rank: sf_rank)

      expect(FindEligibleSubmissionId.(judge)).to eq(sub.id)
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
        sub = FactoryGirl.create(:submission, :complete, team: different_region_team, contest_rank: sf_rank)

        expect(FindEligibleSubmissionId.(judge)).to eq(sub.id)
      end

      it "returns submission id from team in different division" do
        judge = FactoryGirl.create(:judge)
        judge.account.mentor_profile = FactoryGirl.create(:mentor)

        judges_team = FactoryGirl.create(:team, division: Division.senior)
        judge.teams << judges_team

        different_division_team = FactoryGirl.create(:team, division: Division.junior)
        sub = FactoryGirl.create(:submission, :complete, team: different_division_team, contest_rank: sf_rank)

        expect(FindEligibleSubmissionId.(judge)).to eq(sub.id)
      end

      it "does not return submission id from judge's team" do
        judge = FactoryGirl.create(:judge)
        judge.account.mentor_profile = FactoryGirl.create(:mentor)

        judges_team = FactoryGirl.create(:team)
        judge.teams << judges_team
        FactoryGirl.create(:submission, :complete, team: judges_team, contest_rank: sf_rank)

        expect(FindEligibleSubmissionId.(judge)).to be_nil
      end

      it "does not return submission id from team in same region and division" do
        judge = FactoryGirl.create(:judge)
        judge.account.mentor_profile = FactoryGirl.create(:mentor)

        judges_team = FactoryGirl.create(:team)
        judge.teams << judges_team

        same_region_division_team = FactoryGirl.create(:team)
        FactoryGirl.create(:submission, :complete, team: same_region_division_team, contest_rank: sf_rank)

        expect(FindEligibleSubmissionId.(judge)).to be_nil
      end
    end
  end
end
