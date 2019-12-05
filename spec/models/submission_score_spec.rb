require "rails_helper"

RSpec.describe SubmissionScore do
  describe "regioning" do
    it "works with primary region searches" do
      FactoryBot.create(:submission_score, :los_angeles)
      chi = FactoryBot.create(:submission_score, :chicago)
      ra = FactoryBot.create(:ambassador, :chicago)

      expect(SubmissionScore.in_region(ra)).to contain_exactly(chi)
    end

    it "works with secondary region searches" do
      FactoryBot.create(:submission_score, :brazil)
      la = FactoryBot.create(:submission_score, :los_angeles)
      chi = FactoryBot.create(:submission_score, :chicago)

      ra = FactoryBot.create(
        :ambassador,
        :chicago,
        secondary_regions: ["CA, US"])

      expect(SubmissionScore.in_region(ra)).to contain_exactly(chi, la)
    end
  end

  it "acts as paranoid" do
    team = FactoryBot.create(:team)
    judge = FactoryBot.create(:judge_profile)
    team_submission = TeamSubmission.create!(
      team_id: team.id,
      integrity_affirmed: true
    )
    score = SubmissionScore.create!(
      team_submission: team_submission,
      judge_profile: judge
    )

    score.destroy

    expect(SubmissionScore.all).to be_empty
    expect(score).to be_deleted
  end

  it "cannot be duplicated for the same submission and judge" do
    team = Team.create!(
      name: "A",
      description: "B",
      division: Division.senior
    )

    team_submission = TeamSubmission.create!(
      team_id: team.id,
      integrity_affirmed: true
    )
    judge_profile = FactoryBot.create(:judge_profile)

    second_team_submission = TeamSubmission.create!(
      team_id: team.id,
      integrity_affirmed: true
    )
    second_judge_profile = FactoryBot.create(:judge_profile)

    SubmissionScore.create!(
      judge_profile_id: judge_profile.id,
      team_submission_id: team_submission.id,
    )

    expect {
      SubmissionScore.create!(
        judge_profile_id: judge_profile.id,
        team_submission_id: team_submission.id,
      )
    }.to raise_error(ActiveRecord::RecordInvalid)

    expect {
      SubmissionScore.create!(
        judge_profile_id: judge_profile.id,
        team_submission_id: second_team_submission.id,
      )

      SubmissionScore.create!(
        judge_profile_id: second_judge_profile.id,
        team_submission_id: team_submission.id,
      )
    }.not_to raise_error
  end

  it "calculates scores" do
    team = Team.create!(name: "A", description: "B", division: Division.senior)
    team_submission = TeamSubmission.create!(
      team_id: team.id,
      integrity_affirmed: true
    )
    judge_profile = FactoryBot.create(:judge_profile)

    subscore = SubmissionScore.create!({
      team_submission: team_submission,
      judge_profile: judge_profile,

      evidence_of_problem: 5,
      problem_addressed: 4,
      app_functional: 2,

      demo: 0,
      business_plan_short_term: 5,
      business_plan_long_term: 5,
      market_research: 3,

      viable_business_model: 4,
      problem_clearly_communicated: 2,
      compelling_argument: 1,
      passion_energy: 5,

      pitch_specific: 5,
      business_plan_feasible: 4,
      submission_thought_out: 4,

      cohesive_story: 4,
      solution_originality: 3,
      solution_stands_out: 5,
    })

    expect(subscore.total).to eq(61)
  end

  it "calculates total possible score based on division" do
    team = Team.create!(name: "A", description: "B", division: Division.senior)
    team_submission = TeamSubmission.create!(
      team_id: team.id,
      integrity_affirmed: true
    )
    judge_profile = FactoryBot.create(:judge_profile)

    subscore = SubmissionScore.create!({
      team_submission: team_submission,
      judge_profile: judge_profile,
    })

    expect(subscore.total_possible).to eq(90)

    team.division = Division.junior
    team.save!

    team_submission.reload

    expect(subscore.total_possible).to eq(70)
  end

  [:quarterfinals, :semifinals].each do |judging_round|
    context judging_round do

      let(:round) { SubmissionScore.rounds[judging_round] }

      it "udpates team submission average on save when complete" do
        team = FactoryBot.create(:team)
        team_submission = FactoryBot.create(:team_submission, :complete, team: team)
        judge_profile = FactoryBot.create(:judge_profile)

        sub = SubmissionScore.create!(
          judge_profile_id: judge_profile.id,
          team_submission_id: team_submission.id,
          evidence_of_problem: 5,
          round: round,
        )

        sub.complete!
        expect(
          team_submission.reload.public_send("#{judging_round}_average_score")
        ).to eq(5)

        sub.update_attributes(evidence_of_problem: 4)
        expect(
          team_submission.reload.public_send("#{judging_round}_average_score")
        ).to eq(4)

        judge_profile2 = FactoryBot.create(:judge_profile)

        sub2 = SubmissionScore.create!(
          judge_profile_id: judge_profile2.id,
          team_submission_id: team_submission.id,
          evidence_of_problem: 2,
          round: round,
        )

        sub2.complete!
        expect(
          team_submission.reload.public_send("#{judging_round}_average_score")
        ).to eq(3)
      end

      it "does not update a team submission average score if it is not complete" do
        team = FactoryBot.create(:team)
        team_submission = FactoryBot.create(:team_submission, :complete, team: team)
        judge_profile = FactoryBot.create(:judge_profile)

        SubmissionScore.create!(
          judge_profile_id: judge_profile.id,
          team_submission_id: team_submission.id,
          evidence_of_problem: 5,
          round: round,
        )
        expect(
          team_submission.reload.public_send("#{judging_round}_average_score")
        ).to be_zero
      end
    end
  end

  it "sets the event_type to virtual for virtual judges" do
    team = FactoryBot.create(:team)
    team_submission = FactoryBot.create(
      :team_submission,
      :complete,
      team: team
    )
    judge_profile = FactoryBot.create(:judge_profile)

    score = SubmissionScore.create!(
      judge_profile_id: judge_profile.id,
      team_submission_id: team_submission.id,
    )

    expect(score.event_type).to eq("virtual")
  end

  it "sets the event_type to live for RPE judges" do
    SeasonToggles.set_judging_round(:qf)

    team = FactoryBot.create(:team)
    team_submission = FactoryBot.create(
      :team_submission,
      :complete,
      team: team
    )
    judge_profile = FactoryBot.create(:judge_profile)

    rpe = FactoryBot.create(:event,
      name: "RPE",
      starts_at: Date.today,
      ends_at: Date.today + 1.day,
      division_ids: Division.senior.id,
    )

    judge_profile.regional_pitch_events << rpe
    judge_profile.save!

    score = SubmissionScore.create!(
      judge_profile_id: judge_profile.id,
      team_submission_id: team_submission.id,
    )

    expect(score.event_type).to eq("live")

    SeasonToggles.clear_judging_round
  end

  it "does not re-set the event type if the judge changes" do
    SeasonToggles.set_judging_round(:qf)

    team = FactoryBot.create(:team)
    team_submission = FactoryBot.create(
      :team_submission,
      :complete,
      team: team
    )
    judge_profile = FactoryBot.create(:judge_profile)

    rpe = FactoryBot.create(:event,
      name: "RPE",
      starts_at: Date.today,
      ends_at: Date.today + 1.day,
      division_ids: Division.senior.id,
    )

    judge_profile.regional_pitch_events << rpe
    judge_profile.save!

    score = SubmissionScore.create!(
      judge_profile_id: judge_profile.id,
      team_submission_id: team_submission.id,
    )

    expect(score.event_type).to eq("live")

    InvalidateExistingJudgeData.(judge_profile)

    expect(score.event_type).to eq("live")

    SeasonToggles.clear_judging_round
  end

  it "only counts itself on the submission when it's complete" do
    team = FactoryBot.create(:team)
    team_submission = FactoryBot.create(:team_submission, :complete, team: team)
    judge_profile = FactoryBot.create(:judge_profile)

    score = SubmissionScore.create!({
      judge_profile: judge_profile,
      team_submission: team_submission,
    })

    team_submission.reload
    expect(
      team_submission.pending_quarterfinals_submission_scores_count
    ).to eq(1)

    expect(
      team_submission.complete_quarterfinals_submission_scores_count
    ).to eq(0)

    score.complete!

    team_submission.reload
    expect(
      team_submission.pending_quarterfinals_submission_scores_count
    ).to eq(0)

    expect(
      team_submission.complete_quarterfinals_submission_scores_count
    ).to eq(1)
  end

  describe ".current_round" do
    it "pulls QF scores" do
      qf = FactoryBot.create(:score, round: :quarterfinals)
      FactoryBot.create(:score, round: :semifinals)

      set_judging_round("QF")

      expect(SubmissionScore.current_round).to eq([qf])

      reset_judging_round
    end

    it "pulls SF scores" do
      sf = FactoryBot.create(:score, round: :semifinals)
      FactoryBot.create(:score, round: :quarterfinals)

      set_judging_round("SF")

      expect(SubmissionScore.current_round).to eq([sf])

      reset_judging_round
    end
  end

  describe ".event_name" do
    it "has live event name" do
      team = FactoryBot.create(:team)
      team_submission = FactoryBot.create(
        :team_submission,
        :complete,
        team: team
      )
      judge_profile = FactoryBot.create(:judge_profile)
      rpe = FactoryBot.create(:event,
        name: "My RPE",
        starts_at: Date.today,
        ends_at: Date.today + 1.day,
        division_ids: Division.senior.id,
      )

      judge_profile.regional_pitch_events << rpe
      team.regional_pitch_events << rpe

      score = SubmissionScore.create!(
        judge_profile_id: judge_profile.id,
        team_submission_id: team_submission.id,
      )

      expect(score.event_name).to eq("My RPE")
    end

    it "has virtual event name" do
      score = FactoryBot.create(:score)

      expect(score.event_name).to eq("Online Judging")
    end
  end

  describe ".event_official_status" do
    it "has official live event status" do
      rpe = FactoryBot.create(:rpe, unofficial: false)
      score = FactoryBot.create(:score)

      score.judge_profile.regional_pitch_events << rpe
      score.team.regional_pitch_events << rpe

      expect(score.event_official_status).to eq("official")
    end

    it "has unofficial live event status" do
      rpe = FactoryBot.create(:rpe, unofficial: true)
      score = FactoryBot.create(:score)

      score.judge_profile.regional_pitch_events << rpe
      score.team.regional_pitch_events << rpe

      expect(score.event_official_status).to eq("unofficial")
    end

    it "has virtual status" do
      score = FactoryBot.create(:score)

      expect(score.event_official_status).to eq("virtual")
    end
  end
end
