require "rails_helper"

RSpec.describe FindEligibleSubmissionId do
  let(:senior_division_age) { Division::SENIOR_DIVISION_AGE }
  let(:senior_dob) { Division.cutoff_date - senior_division_age.years }

  context "quarterfinals" do
    before { set_judging_round("QF") }
    after { reset_judging_round }

    it "does not pick incomplete submissions" do
      judge = FactoryBot.create(:judge)
      team = FactoryBot.create(:team)
      FactoryBot.create(:submission, team: team)

      expect(FindEligibleSubmissionId.call(judge)).to be_nil
    end

    it "picks submissions with fewest scores" do
      judge1 = FactoryBot.create(:judge)
      team1 = FactoryBot.create(:team)
      submission_with_score = FactoryBot.create(
        :submission,
        :complete,
        team: team1
      )
      SubmissionScore.create!(
        judge_profile_id: judge1.id,
        team_submission_id: submission_with_score.id,
        completed_at: Time.current
      )

      judge2 = FactoryBot.create(:judge)
      team2 = FactoryBot.create(:team)
      submission_without_score = FactoryBot.create(
        :submission,
        :complete,
        team: team2
      )

      expect(FindEligibleSubmissionId.call(judge2)).to eq(submission_without_score.id)
    end

    it "prefers submissions with less than #{FindEligibleSubmissionId::SCORE_COUNT_LIMIT} complete scores" do
      team = FactoryBot.create(:team)
      submission = FactoryBot.create(:submission, :complete, team: team)

      (FindEligibleSubmissionId::SCORE_COUNT_LIMIT - 1).times do
        j = FactoryBot.create(:judge)
        FactoryBot.create(:score, :complete,
          team_submission: submission,
          judge_profile: j)
      end

      judge = FactoryBot.create(:judge)

      FactoryBot.create(:score, :incomplete,
        team_submission: submission,
        judge_profile: judge)

      expect(FindEligibleSubmissionId.call(judge)).to eq(submission.id)

      judge2 = FactoryBot.create(:judge)
      FactoryBot.create(:score, :complete,
        team_submission: submission,
        judge_profile: judge2)

      judge3 = FactoryBot.create(:judge)
      expect(FindEligibleSubmissionId.call(judge3)).to be_nil
    end

    it "picks submission with no scores over pending scores" do
      submission_a = FactoryBot.create(:submission, :complete)
      submission_b = FactoryBot.create(:submission, :complete)

      FactoryBot.create(:score, :incomplete,
        team_submission: submission_b)

      judge = FactoryBot.create(:judge)

      expect(FindEligibleSubmissionId.call(judge)).to eq(submission_a.id)
    end

    it "spreads pending scores evenly" do
      submission_a = FactoryBot.create(:submission, :complete)
      submission_b = FactoryBot.create(:submission, :complete)

      10.times do
        id = FindEligibleSubmissionId.call(FactoryBot.create(:judge))
        picked = [submission_a, submission_b].find { |submission| submission.id == id }

        FactoryBot.create(:score, :incomplete,
          team_submission: picked)
      end

      expect(submission_a.submission_scores.incomplete.count).to eq(5)
      expect(submission_b.submission_scores.incomplete.count).to eq(5)
    end

    it "does not count pending scores in max score calculation" do
      submission = FactoryBot.create(:submission, :complete)

      11.times do
        FactoryBot.create(:score, :incomplete,
          team_submission: submission)
      end

      expect(FindEligibleSubmissionId.call(FactoryBot.create(:judge))).to eq(submission.id)
    end

    it "does not pick submissions that a judge has previously completed" do
      team = FactoryBot.create(:team)
      submission = FactoryBot.create(:submission, :complete, team: team)

      judge = FactoryBot.create(:judge)
      score = SubmissionScore.create!(
        judge_profile: judge,
        team_submission: submission
      )

      score.complete!

      expect(FindEligibleSubmissionId.call(judge)).to be_nil
    end

    it "does not pick submissions that a judge has been recused from" do
      judge = FactoryBot.create(:judge)
      team = FactoryBot.create(:team)
      submission = FactoryBot.create(:submission, :complete, team: team)

      SubmissionScore.create!(
        judge_profile: judge,
        team_submission: submission,
        judge_recusal: true,
        judge_recusal_reason: "submission_not_in_english"
      )

      expect(FindEligibleSubmissionId.call(judge)).to be_nil
    end

    it "picks submission for an unofficial regional pitch event" do
      judge = FactoryBot.create(:judge)
      team = FactoryBot.create(:team)

      team.regional_pitch_events << FactoryBot.create(:event,
        starts_at: Date.today,
        ends_at: Date.today + 1.day,
        division_ids: Division.senior.id,
        unofficial: true)

      submission = FactoryBot.create(:submission, :complete, team: team)

      expect(FindEligibleSubmissionId.call(judge)).to eq(submission.id)
    end

    it "ignores unofficial live scores when selecting" do
      unofficial_rpe = FactoryBot.create(:rpe, unofficial: true)

      team1 = FactoryBot.create(:team)
      team1.regional_pitch_events << unofficial_rpe
      submission_with_unofficial_scores = FactoryBot.create(:submission, :complete, team: team1)

      team2 = FactoryBot.create(:team)
      submission_with_official_score = FactoryBot.create(:submission, :complete, team: team2)

      rpe_judge1 = FactoryBot.create(:judge)
      rpe_judge1.regional_pitch_events << unofficial_rpe
      SubmissionScore.create!(
        judge_profile_id: rpe_judge1.id,
        team_submission_id: submission_with_unofficial_scores.id
      )

      rpe_judge2 = FactoryBot.create(:judge)
      rpe_judge2.regional_pitch_events << unofficial_rpe
      SubmissionScore.create!(
        judge_profile_id: rpe_judge2.id,
        team_submission_id: submission_with_unofficial_scores.id
      )

      judge3 = FactoryBot.create(:judge)
      SubmissionScore.create!(
        judge_profile_id: judge3.id,
        team_submission_id: submission_with_official_score.id
      )

      expect(FindEligibleSubmissionId.call(FactoryBot.create(:judge))).to eq(
        submission_with_unofficial_scores.id
      )
    end

    it "does not pick submissions for an official regional pitch event" do
      judge = FactoryBot.create(:judge)
      team = FactoryBot.create(:team)
      team.regional_pitch_events << FactoryBot.create(:event,
        starts_at: Date.today,
        ends_at: Date.today + 1.day,
        division_ids: Division.senior.id)

      TeamSubmission.create!({
        integrity_affirmed: true,
        team: team
      })

      expect(FindEligibleSubmissionId.call(judge)).to be_nil
    end

    context "judge without team" do
      it "returns submission id" do
        judge = FactoryBot.create(:judge)
        team = FactoryBot.create(:team)
        submission = FactoryBot.create(:submission, :complete, team: team)

        expect(FindEligibleSubmissionId.call(judge)).to eq(submission.id)
      end
    end

    context "when a score_id is provided via the 'options' argument" do
      it "returns the submission_id for the provided score_id" do
        judge = FactoryBot.create(:judge)
        team = FactoryBot.create(:team)
        submission1 = FactoryBot.create(:submission, :complete, team: team)
        submission2 = FactoryBot.create(:submission, :complete, team: team)
        submission3 = FactoryBot.create(:submission, :complete, team: team)

        SubmissionScore.create!(
          judge_profile_id: judge.id,
          team_submission_id: submission1.id,
          round: "quarterfinals"
        )

        SubmissionScore.create!(
          judge_profile_id: judge.id,
          team_submission_id: submission2.id,
          round: "quarterfinals"
        )

        score_id = SubmissionScore.create!(
          judge_profile_id: judge.id,
          team_submission_id: submission3.id,
          round: "quarterfinals"
        ).id

        expect(FindEligibleSubmissionId.call(judge, {score_id: score_id})).to eq(submission3.id)
      end
    end

    context "judge with team" do
      it "returns submission id from team in different region" do
        judge = FactoryBot.create(:judge)
        judge.account.mentor_profile = FactoryBot.create(:mentor, :onboarded)

        judges_team = FactoryBot.create(:team, division: Division.senior)
        judge.teams << judges_team

        different_region_team = FactoryBot.create(
          :team,
          city: "Los Angeles",
          state_province: "CA",
          division: Division.senior
        )
        submission = FactoryBot.create(:submission, :complete, team: different_region_team)

        expect(FindEligibleSubmissionId.call(judge)).to eq(submission.id)
      end

      it "returns submission id from team in different division" do
        judge = FactoryBot.create(:judge)
        judge.account.mentor_profile = FactoryBot.create(:mentor, :onboarded)

        judges_team = FactoryBot.create(:team)

        judges_team.students.each do |student|
          ProfileUpdating.execute(
            student,
            nil,
            {account_attributes: {
              id: student.account_id,
              date_of_birth: senior_dob
            }}
          )
        end

        judge.teams << judges_team

        different_division_team = FactoryBot.create(:team) # junior by default
        submission = FactoryBot.create(:submission, :complete, team: different_division_team)

        expect(FindEligibleSubmissionId.call(judge)).to eq(submission.id)
      end

      it "does not return submission id from judge's team" do
        judge = FactoryBot.create(:judge)
        judge.account.mentor_profile = FactoryBot.create(:mentor, :onboarded)

        judges_team = FactoryBot.create(:team)
        judge.teams << judges_team
        FactoryBot.create(:submission, :complete, team: judges_team)

        expect(FindEligibleSubmissionId.call(judge)).to be_nil
      end

      it "does not return submission id from team in same region and division" do
        judge = FactoryBot.create(:judge)
        judge.account.mentor_profile = FactoryBot.create(:mentor, :onboarded)

        judges_team = FactoryBot.create(:team)
        judge.teams << judges_team

        same_region_division_team = FactoryBot.create(:team)
        FactoryBot.create(:submission, :complete, team: same_region_division_team)

        expect(FindEligibleSubmissionId.call(judge)).to be_nil
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
      FactoryBot.create(
        :submission,
        :complete,
        team: team,
        contest_rank: TeamSubmission.contest_ranks[:quarterfinalist]
      )

      expect(FindEligibleSubmissionId.call(judge)).to be_nil
    end

    it "chooses semifinalist submission" do
      judge = FactoryBot.create(:judge)
      team = FactoryBot.create(:team)
      submission = FactoryBot.create(
        :submission,
        :complete,
        team: team,
        contest_rank: sf_rank
      )

      expect(FindEligibleSubmissionId.call(judge)).to eq(submission.id)
    end

    it "chooses submissions with fewest semifinals scores" do
      judge1 = FactoryBot.create(:judge)
      team1 = FactoryBot.create(:team)
      submission_with_sf_score = FactoryBot.create(
        :submission,
        :complete,
        team: team1,
        contest_rank: sf_rank
      )

      SubmissionScore.create!(
        judge_profile_id: judge1.id,
        team_submission_id: submission_with_sf_score.id,
        round: SubmissionScore.rounds[:semifinals],
        completed_at: Time.current
      )

      judge2 = FactoryBot.create(:judge)
      team2 = FactoryBot.create(:team)
      submission_without_sf_score = FactoryBot.create(
        :submission,
        :complete,
        team: team2,
        contest_rank: sf_rank
      )

      SubmissionScore.create!(
        judge_profile_id: judge1.id,
        team_submission_id: submission_without_sf_score.id,
        round: qf_round
      )
      SubmissionScore.create!(
        judge_profile_id: FactoryBot.create(:judge).id,
        team_submission_id: submission_without_sf_score.id,
        round: qf_round
      )

      expect(FindEligibleSubmissionId.call(judge2)).to eq(submission_without_sf_score.id)
    end

    it "does not select submission judged in quarterfinals" do
      judge = FactoryBot.create(:judge)
      team = FactoryBot.create(:team)
      submission = FactoryBot.create(:submission, :complete, team: team, contest_rank: sf_rank)
      score = SubmissionScore.create!(
        judge_profile_id: judge.id,
        team_submission_id: submission.id,
        round: qf_round
      )
      score.complete!

      expect(FindEligibleSubmissionId.call(judge)).to be_nil
    end

    it "does not select submission judged already in semifinals" do
      judge = FactoryBot.create(:judge)
      team = FactoryBot.create(:team)
      submission = FactoryBot.create(:submission, :complete, team: team, contest_rank: sf_rank)
      score = SubmissionScore.create!(
        judge_profile_id: judge.id,
        team_submission_id: submission.id,
        round: sf_round
      )
      score.complete!

      expect(FindEligibleSubmissionId.call(judge)).to be_nil
    end

    it "picks submission for an official regional pitch event" do
      judge = FactoryBot.create(:judge)
      team = FactoryBot.create(:team)
      team.regional_pitch_events << FactoryBot.create(:event,
        starts_at: Date.today,
        ends_at: Date.today + 1.day,
        division_ids: Division.senior.id)

      submission = FactoryBot.create(
        :submission,
        :complete,
        team: team,
        contest_rank: sf_rank
      )

      expect(FindEligibleSubmissionId.call(judge)).to eq(submission.id)
    end

    context "judge with team" do
      it "returns submission id from team in different region" do
        judge = FactoryBot.create(:judge)
        judge.account.mentor_profile = FactoryBot.create(:mentor, :onboarded)

        judges_team = FactoryBot.create(:team, division: Division.senior)
        judge.teams << judges_team

        different_region_team = FactoryBot.create(
          :team,
          city: "Los Angeles",
          state_province: "CA",
          division: Division.senior
        )
        submission = FactoryBot.create(
          :submission,
          :complete,
          team: different_region_team,
          contest_rank: sf_rank
        )

        expect(FindEligibleSubmissionId.call(judge)).to eq(submission.id)
      end

      it "returns submission id from team in different division" do
        judge = FactoryBot.create(:judge)
        judge.account.mentor_profile = FactoryBot.create(:mentor, :onboarded)

        judges_team = FactoryBot.create(:team)

        judges_team.students.each do |student|
          ProfileUpdating.execute(
            student,
            nil,
            {account_attributes: {
              id: student.account_id,
              date_of_birth: senior_dob
            }}
          )
        end

        judge.teams << judges_team

        different_division_team = FactoryBot.create(:team)
        submission = FactoryBot.create(
          :submission,
          :complete,
          team: different_division_team,
          contest_rank: sf_rank
        )

        expect(FindEligibleSubmissionId.call(judge)).to eq(submission.id)
      end

      it "does not return submission id from judge's team" do
        judge = FactoryBot.create(:judge)
        judge.account.mentor_profile = FactoryBot.create(:mentor, :onboarded)

        judges_team = FactoryBot.create(:team)
        judge.teams << judges_team
        FactoryBot.create(:submission, :complete, team: judges_team, contest_rank: sf_rank)

        expect(FindEligibleSubmissionId.call(judge)).to be_nil
      end

      it "does not return submission id from team in same region and division" do
        judge = FactoryBot.create(:judge)
        judge.account.mentor_profile = FactoryBot.create(:mentor, :onboarded)

        judges_team = FactoryBot.create(:team)
        judge.teams << judges_team

        same_region_division_team = FactoryBot.create(:team)
        FactoryBot.create(
          :submission,
          :complete,
          team: same_region_division_team,
          contest_rank: sf_rank
        )

        expect(FindEligibleSubmissionId.call(judge)).to be_nil
      end
    end
  end
end
