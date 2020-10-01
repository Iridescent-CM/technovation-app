require "rails_helper"

RSpec.describe FindEligibleSubmissionId do
  let(:senior_division_age) { Division::SENIOR_DIVISION_AGE }
  let(:senior_dob) { Division.cutoff_date - senior_division_age.years }

  context "quarterfinals" do
    before { set_judging_round("QF") }
    after { reset_judging_round }

    it "does not choose incomplete submission" do
      judge = FactoryBot.create(:judge)
      team = FactoryBot.create(:team)
      FactoryBot.create(:submission, team: team)

      expect(FindEligibleSubmissionId.(judge)).to be_nil
    end

    it "chooses submissions with fewest scores" do
      judge1 = FactoryBot.create(:judge)
      team1 = FactoryBot.create(:team)
      sub_with_score = FactoryBot.create(
        :submission,
        :complete,
        team: team1
      )
      SubmissionScore.create!(
        judge_profile_id: judge1.id,
        team_submission_id: sub_with_score.id,
        completed_at: Time.current,
      )

      judge2 = FactoryBot.create(:judge)
      team2 = FactoryBot.create(:team)
      sub_without_score = FactoryBot.create(
        :submission,
        :complete,
        team: team2
      )

      expect(FindEligibleSubmissionId.(judge2)).to eq(sub_without_score.id)
    end

    it "prefers submissions with less than #{FindEligibleSubmissionId::SCORE_COUNT_LIMIT} complete scores" do
      team = FactoryBot.create(:team)
      sub = FactoryBot.create(:submission, :complete, team: team)

      (FindEligibleSubmissionId::SCORE_COUNT_LIMIT - 1).times do
        j = FactoryBot.create(:judge)
        FactoryBot.create(:score, :complete,
          team_submission: sub,
          judge_profile: j
        )
      end

      judge = FactoryBot.create(:judge)

      FactoryBot.create(:score, :incomplete,
        team_submission: sub,
        judge_profile: judge
      )

      expect(FindEligibleSubmissionId.(judge)).to eq(sub.id)

      judge2 = FactoryBot.create(:judge)
      FactoryBot.create(:score, :complete,
        team_submission: sub,
        judge_profile: judge2
      )

      judge3 = FactoryBot.create(:judge)
      expect(FindEligibleSubmissionId.(judge3)).to be_nil
    end

    it "selects submission with no scores over pending scores" do
      sub_a = FactoryBot.create(:submission, :complete)
      sub_b = FactoryBot.create(:submission, :complete)

      FactoryBot.create(:score, :incomplete,
        team_submission: sub_b
      )

      judge = FactoryBot.create(:judge)

      expect(FindEligibleSubmissionId.(judge)).to eq(sub_a.id)
    end

    it "spreads pending scores evenly" do
      sub_a = FactoryBot.create(:submission, :complete)
      sub_b = FactoryBot.create(:submission, :complete)

      10.times do
        id = FindEligibleSubmissionId.(FactoryBot.create(:judge))
        picked = [sub_a, sub_b].select { |sub| sub.id == id }.first
        FactoryBot.create(:score, :incomplete,
          team_submission: picked
        )
      end

      expect(sub_a.submission_scores.incomplete.count).to eq(5)
      expect(sub_b.submission_scores.incomplete.count).to eq(5)
    end

    it "does not count pending scores in max score calculation" do
      sub = FactoryBot.create(:submission, :complete)

      11.times do
        FactoryBot.create(:score, :incomplete,
          team_submission: sub
        )
      end

      expect(FindEligibleSubmissionId.(FactoryBot.create(:judge))).to eq(sub.id)
    end

    it "does not reselect previously judged submission" do
      team = FactoryBot.create(:team)
      sub = FactoryBot.create(:submission, :complete, team: team)

      judge = FactoryBot.create(:judge)
      score = SubmissionScore.create!(
        judge_profile: judge,
        team_submission: sub,
      )

      score.complete!

      expect(FindEligibleSubmissionId.(judge)).to be_nil
    end

    it "selects submission for an unofficial regional pitch event" do
      judge = FactoryBot.create(:judge)
      team = FactoryBot.create(:team)

      team.regional_pitch_events << FactoryBot.create(:event,
        starts_at: Date.today,
        ends_at: Date.today + 1.day,
        division_ids: Division.senior.id,
        unofficial: true,
      )

      sub = FactoryBot.create(:submission, :complete, team: team)

      expect(FindEligibleSubmissionId.(judge)).to eq(sub.id)
    end

    it "ignores unofficial live scores when selecting" do
      unofficial_rpe = FactoryBot.create(:rpe, unofficial: true)

      team1 = FactoryBot.create(:team)
      team1.regional_pitch_events << unofficial_rpe
      sub_with_unofficial_scores = FactoryBot.create(:submission, :complete, team: team1)

      team2 = FactoryBot.create(:team)
      sub_with_official_score = FactoryBot.create(:submission, :complete, team: team2)

      rpe_judge1 = FactoryBot.create(:judge)
      rpe_judge1.regional_pitch_events << unofficial_rpe
      SubmissionScore.create!(
        judge_profile_id: rpe_judge1.id,
        team_submission_id: sub_with_unofficial_scores.id
      )

      rpe_judge2 = FactoryBot.create(:judge)
      rpe_judge2.regional_pitch_events << unofficial_rpe
      SubmissionScore.create!(
        judge_profile_id: rpe_judge2.id,
        team_submission_id: sub_with_unofficial_scores.id
      )

      judge3 = FactoryBot.create(:judge)
      SubmissionScore.create!(
        judge_profile_id: judge3.id,
        team_submission_id: sub_with_official_score.id
      )

      expect(FindEligibleSubmissionId.(FactoryBot.create(:judge))).to eq(
        sub_with_unofficial_scores.id
      )
    end

    it "does not select submission for an official regional pitch event" do
      judge = FactoryBot.create(:judge)
      team = FactoryBot.create(:team)
      team.regional_pitch_events << FactoryBot.create(:event,
        starts_at: Date.today,
        ends_at: Date.today + 1.day,
        division_ids: Division.senior.id,
      )

      TeamSubmission.create!({
        integrity_affirmed: true,
        team: team,
      })

      expect(FindEligibleSubmissionId.(judge)).to be_nil
    end

    context "judge without team" do
      it "returns submission id" do
        judge = FactoryBot.create(:judge)
        team = FactoryBot.create(:team)
        sub = FactoryBot.create(:submission, :complete, team: team)

        expect(FindEligibleSubmissionId.(judge)).to eq(sub.id)
      end
    end

    context "judge with team" do
      it "returns submission id from team in different region" do
        judge = FactoryBot.create(:judge)
        judge.account.mentor_profile = FactoryBot.create(:mentor, :onboarded)

        judges_team = FactoryBot.create(:team, division: Division.senior)
        judge.teams << judges_team

        different_region_team = FactoryBot.create(:team,
                                                   city: "Los Angeles",
                                                   state_province: "CA",
                                                   division: Division.senior)
        sub = FactoryBot.create(:submission, :complete, team: different_region_team)

        expect(FindEligibleSubmissionId.(judge)).to eq(sub.id)
      end

      it "returns submission id from team in different division" do
        judge = FactoryBot.create(:judge)
        judge.account.mentor_profile = FactoryBot.create(:mentor, :onboarded)

        judges_team = FactoryBot.create(:team)

        judges_team.students.each do |s|
          ProfileUpdating.execute(s, account_attributes: {
              id: s.account_id,
              date_of_birth: senior_dob
          })
        end

        judge.teams << judges_team

        different_division_team = FactoryBot.create(:team) # junior by default
        sub = FactoryBot.create(:submission, :complete, team: different_division_team)

        expect(FindEligibleSubmissionId.(judge)).to eq(sub.id)
      end

      it "does not return submission id from judge's team" do
        judge = FactoryBot.create(:judge)
        judge.account.mentor_profile = FactoryBot.create(:mentor, :onboarded)

        judges_team = FactoryBot.create(:team)
        judge.teams << judges_team
        FactoryBot.create(:submission, :complete, team: judges_team)

        expect(FindEligibleSubmissionId.(judge)).to be_nil
      end

      it "does not return submission id from team in same region and division" do
        judge = FactoryBot.create(:judge)
        judge.account.mentor_profile = FactoryBot.create(:mentor, :onboarded)

        judges_team = FactoryBot.create(:team)
        judge.teams << judges_team

        same_region_division_team = FactoryBot.create(:team)
        FactoryBot.create(:submission, :complete, team: same_region_division_team)

        expect(FindEligibleSubmissionId.(judge)).to be_nil
      end
    end
  end

  context "semifinals" do
    before { set_judging_round("SF") }
    after { reset_judging_round }

    let(:sf_rank) { TeamSubmission.contest_ranks[:semifinalist] }
    let(:qf_round) { SubmissionScore.rounds[:quarterfinals] }
    let(:sf_round) { SubmissionScore.rounds[:semifinals] }

    it "does not choose quarterfinalist submission" do
      judge = FactoryBot.create(:judge)
      team = FactoryBot.create(:team)
      FactoryBot.create(:submission,
                         :complete,
                         team: team,
                         contest_rank: TeamSubmission.contest_ranks[:quarterfinalist])

      expect(FindEligibleSubmissionId.(judge)).to be_nil
    end

    it "chooses semifinalist submission" do
      judge = FactoryBot.create(:judge)
      team = FactoryBot.create(:team)
      submission = FactoryBot.create(:submission,
                                      :complete,
                                      team: team,
                                      contest_rank: sf_rank)

      expect(FindEligibleSubmissionId.(judge)).to eq(submission.id)
    end

    it "chooses submissions with fewest semifinals scores" do
      judge1 = FactoryBot.create(:judge)
      team1 = FactoryBot.create(:team)
      sub_with_sf_score = FactoryBot.create(:submission,
                                             :complete,
                                             team: team1,
                                             contest_rank: sf_rank)
      SubmissionScore.create!(
        judge_profile_id: judge1.id,
        team_submission_id: sub_with_sf_score.id,
        round: SubmissionScore.rounds[:semifinals],
        completed_at: Time.current,
      )

      judge2 = FactoryBot.create(:judge)
      team2 = FactoryBot.create(:team)
      sub_without_sf_score = FactoryBot.create(:submission,
                                                :complete,
                                                team: team2,
                                                contest_rank: sf_rank)
      SubmissionScore.create!(
        judge_profile_id: judge1.id,
        team_submission_id: sub_without_sf_score.id,
        round: qf_round
      )
      SubmissionScore.create!(
        judge_profile_id: FactoryBot.create(:judge).id,
        team_submission_id: sub_without_sf_score.id,
        round: qf_round
      )

      expect(FindEligibleSubmissionId.(judge2)).to eq(sub_without_sf_score.id)
    end

    it "does not select submission judged in quarterfinals" do
      judge = FactoryBot.create(:judge)
      team = FactoryBot.create(:team)
      sub = FactoryBot.create(:submission, :complete, team: team, contest_rank: sf_rank)
      score = SubmissionScore.create!(
        judge_profile_id: judge.id,
        team_submission_id: sub.id,
        round: qf_round
      )
      score.complete!

      expect(FindEligibleSubmissionId.(judge)).to be_nil
    end

    it "does not select submission judged already in semifinals" do
      judge = FactoryBot.create(:judge)
      team = FactoryBot.create(:team)
      sub = FactoryBot.create(:submission, :complete, team: team, contest_rank: sf_rank)
      score = SubmissionScore.create!(
        judge_profile_id: judge.id,
        team_submission_id: sub.id,
        round: sf_round
      )
      score.complete!

      expect(FindEligibleSubmissionId.(judge)).to be_nil
    end

    it "selects submission for an official regional pitch event" do
      judge = FactoryBot.create(:judge)
      team = FactoryBot.create(:team)
      team.regional_pitch_events << FactoryBot.create(:event,
        starts_at: Date.today,
        ends_at: Date.today + 1.day,
        division_ids: Division.senior.id,
      )

      sub = FactoryBot.create(
        :submission,
        :complete,
        team: team,
        contest_rank: sf_rank
      )

      expect(FindEligibleSubmissionId.(judge)).to eq(sub.id)
    end

    context "judge with team" do
      it "returns submission id from team in different region" do
        judge = FactoryBot.create(:judge)
        judge.account.mentor_profile = FactoryBot.create(:mentor, :onboarded)

        judges_team = FactoryBot.create(:team, division: Division.senior)
        judge.teams << judges_team

        different_region_team = FactoryBot.create(:team,
                                                   city: "Los Angeles",
                                                   state_province: "CA",
                                                   division: Division.senior)
        sub = FactoryBot.create(:submission,
                                 :complete,
                                 team: different_region_team,
                                 contest_rank: sf_rank)

        expect(FindEligibleSubmissionId.(judge)).to eq(sub.id)
      end

      it "returns submission id from team in different division" do
        judge = FactoryBot.create(:judge)
        judge.account.mentor_profile = FactoryBot.create(:mentor, :onboarded)

        judges_team = FactoryBot.create(:team)

        judges_team.students.each do |s|
          ProfileUpdating.execute(s, account_attributes: {
              id: s.account_id,
              date_of_birth: senior_dob
          })
        end

        judge.teams << judges_team

        different_division_team = FactoryBot.create(:team)
        sub = FactoryBot.create(:submission,
                                 :complete,
                                 team: different_division_team,
                                 contest_rank: sf_rank)

        expect(FindEligibleSubmissionId.(judge)).to eq(sub.id)
      end

      it "does not return submission id from judge's team" do
        judge = FactoryBot.create(:judge)
        judge.account.mentor_profile = FactoryBot.create(:mentor, :onboarded)

        judges_team = FactoryBot.create(:team)
        judge.teams << judges_team
        FactoryBot.create(:submission, :complete, team: judges_team, contest_rank: sf_rank)

        expect(FindEligibleSubmissionId.(judge)).to be_nil
      end

      it "does not return submission id from team in same region and division" do
        judge = FactoryBot.create(:judge)
        judge.account.mentor_profile = FactoryBot.create(:mentor, :onboarded)

        judges_team = FactoryBot.create(:team)
        judge.teams << judges_team

        same_region_division_team = FactoryBot.create(:team)
        FactoryBot.create(:submission,
                           :complete,
                           team: same_region_division_team,
                           contest_rank: sf_rank)

        expect(FindEligibleSubmissionId.(judge)).to be_nil
      end
    end
  end
end
