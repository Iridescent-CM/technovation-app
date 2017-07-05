require "rails_helper"

RSpec.describe SubmissionScore do
  it "acts as paranoid" do
    team = FactoryGirl.create(:team)
    judge = FactoryGirl.create(:judge_profile)
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
    team = Team.create!(name: "A", description: "B", division: Division.senior)
    team_submission = TeamSubmission.create!(
      team_id: team.id,
      integrity_affirmed: true
    )
    judge_profile = FactoryGirl.create(:judge_profile)

    second_team_submission = TeamSubmission.create!(
      team_id: team.id,
      integrity_affirmed: true
    )
    second_judge_profile = FactoryGirl.create(:judge_profile)

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
    judge_profile = FactoryGirl.create(:judge_profile)

    subscore = SubmissionScore.create!({
      team_submission: team_submission,
      judge_profile: judge_profile,

      sdg_alignment: 3,
      evidence_of_problem: 5,
      problem_addressed: 4,
      app_functional: 2,

      demo_video: 0,
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

    expect(subscore.total).to eq(64)
  end

  it "calculates total possible score based on division" do
    team = Team.create!(name: "A", description: "B", division: Division.senior)
    team_submission = TeamSubmission.create!(
      team_id: team.id,
      integrity_affirmed: true
    )
    judge_profile = FactoryGirl.create(:judge_profile)

    subscore = SubmissionScore.create!({
      team_submission: team_submission,
      judge_profile: judge_profile,
    })

    expect(subscore.total_possible).to eq(100)

    team.division = Division.junior
    team.save!

    team_submission.reload

    expect(subscore.total_possible).to eq(80)
  end

  it "includes tech checklist verification in the score" do
    team = Team.create!(name: "A", description: "B", division: Division.senior)
    team_submission = TeamSubmission.create!(
      team_id: team.id,
      integrity_affirmed: true
    )
    judge_profile = FactoryGirl.create(:judge_profile)

    team_submission.create_technical_checklist!({
      used_canvas: true,
      used_canvas_explanation: "hello",

      used_lists: true,
      used_lists_explanation: "hello",
    })

    subscore = SubmissionScore.create!({
      team_submission: team_submission,
      judge_profile: judge_profile,
    })

    expect(subscore.total).to eq(3)
  end

  it "includes screenshots count as part of tech checklist score" do
    team = Team.create!(name: "A", description: "B", division: Division.senior)
    team_submission = TeamSubmission.create!(
      team_id: team.id,
      integrity_affirmed: true
    )
    judge_profile = FactoryGirl.create(:judge_profile)

    team_submission.create_technical_checklist!({
      used_canvas: true,
      used_canvas_explanation: "hello",

      used_lists: true,
      used_lists_explanation: "hello",
    })

    # 1/2 screenshots, not enough for points
    team_submission.screenshots.create!

    subscore = SubmissionScore.create!({
      team_submission: team_submission,
      judge_profile: judge_profile,
    })

    expect(subscore.total).to eq(3)

    # 2/2 screenshots
    # but not other process stuff
    team_submission.screenshots.create!

    expect(subscore.total).to eq(3)
  end

  it "clears the judge opened id/at on complete" do
    team = Team.create!(name: "A", description: "B", division: Division.senior)
    team_submission = TeamSubmission.create!(
      team_id: team.id,
      integrity_affirmed: true
    )
    judge_profile = FactoryGirl.create(:judge_profile)

    team_submission.update_attributes(
      judge_opened_at: Time.current,
      judge_opened_id: judge_profile.id
    )

    sub = SubmissionScore.create!(
      judge_profile_id: judge_profile.id,
      team_submission_id: team_submission.id,
    )

    sub.complete!
    team_submission.reload

    expect(team_submission.judge_opened_at).to be_blank
    expect(team_submission.judge_opened_id).to be_blank
  end

  [:quarterfinals, :semifinals].each do |judging_round|
    context judging_round do

      let(:round) { SubmissionScore.rounds[judging_round] }

      it "udpates team submission average on save when complete" do
        team = FactoryGirl.create(:team)
        team_submission = FactoryGirl.create(:team_submission, :complete, team: team)
        judge_profile = FactoryGirl.create(:judge_profile)

        sub = SubmissionScore.create!(
          judge_profile_id: judge_profile.id,
          team_submission_id: team_submission.id,
          sdg_alignment: 5,
          round: round,
        )

        sub.complete!
        expect(
          team_submission.reload.public_send("#{judging_round}_average_score")
        ).to eq(5)

        sub.update_attributes(sdg_alignment: 4)
        expect(
          team_submission.reload.public_send("#{judging_round}_average_score")
        ).to eq(4)

        judge_profile2 = FactoryGirl.create(:judge_profile)

        sub2 = SubmissionScore.create!(
          judge_profile_id: judge_profile2.id,
          team_submission_id: team_submission.id,
          sdg_alignment: 2,
          round: round,
        )

        sub2.complete!
        expect(
          team_submission.reload.public_send("#{judging_round}_average_score")
        ).to eq(3)
      end

      it "does not update a team submission average score if it is not complete" do
        team = FactoryGirl.create(:team)
        team_submission = FactoryGirl.create(:team_submission, :complete, team: team)
        judge_profile = FactoryGirl.create(:judge_profile)

        SubmissionScore.create!(
          judge_profile_id: judge_profile.id,
          team_submission_id: team_submission.id,
          sdg_alignment: 5,
          round: round,
        )
        expect(
          team_submission.reload.public_send("#{judging_round}_average_score")
        ).to be_zero
      end
    end
  end

  it "sets the event_type to virtual for virtual judges" do
    team = FactoryGirl.create(:team)
    team_submission = FactoryGirl.create(:team_submission, :complete, team: team)
    judge_profile = FactoryGirl.create(:judge_profile)

    score = SubmissionScore.create!(
      judge_profile_id: judge_profile.id,
      team_submission_id: team_submission.id,
    )

    expect(score.event_type).to eq("virtual")
  end

  it "sets the event_type to live for RPE judges" do
    team = FactoryGirl.create(:team)
    team_submission = FactoryGirl.create(:team_submission, :complete, team: team)
    judge_profile = FactoryGirl.create(:judge_profile)

    rpe = RegionalPitchEvent.create!({
      regional_ambassador_profile: FactoryGirl.create(:regional_ambassador_profile),
      name: "RPE",
      starts_at: Date.today,
      ends_at: Date.today + 1.day,
      division_ids: Division.senior.id,
      city: "City",
      venue_address: "123 Street St.",
    })

    judge_profile.regional_pitch_events << rpe
    judge_profile.save!

    score = SubmissionScore.create!(
      judge_profile_id: judge_profile.id,
      team_submission_id: team_submission.id,
    )

    expect(score.event_type).to eq("live")
  end

  it "does not re-set the event type if the judge changes" do
    team = FactoryGirl.create(:team)
    team_submission = FactoryGirl.create(:team_submission, :complete, team: team)
    judge_profile = FactoryGirl.create(:judge_profile)

    rpe = RegionalPitchEvent.create!({
      regional_ambassador_profile: FactoryGirl.create(:regional_ambassador_profile),
      name: "RPE",
      starts_at: Date.today,
      ends_at: Date.today + 1.day,
      division_ids: Division.senior.id,
      city: "City",
      venue_address: "123 Street St.",
    })

    judge_profile.regional_pitch_events << rpe
    judge_profile.save!

    score = SubmissionScore.create!(
      judge_profile_id: judge_profile.id,
      team_submission_id: team_submission.id,
    )

    expect(score.event_type).to eq("live")

    judge_profile.remove_from_live_event

    expect(score.event_type).to eq("live")
  end

  it "only counts itself on the submission when it's complete" do
    team = FactoryGirl.create(:team)
    team_submission = FactoryGirl.create(:team_submission, :complete, team: team)
    judge_profile = FactoryGirl.create(:judge_profile)

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
      qf = FactoryGirl.create(:score, round: :quarterfinals)
      FactoryGirl.create(:score, round: :semifinals)

      set_judging_round("QF")

      expect(SubmissionScore.current_round).to eq([qf])

      reset_judging_round
    end

    it "pulls SF scores" do
      sf = FactoryGirl.create(:score, round: :semifinals)
      FactoryGirl.create(:score, round: :quarterfinals)

      set_judging_round("SF")

      expect(SubmissionScore.current_round).to eq([sf])

      reset_judging_round
    end
  end
end
