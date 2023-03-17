require "rails_helper"

RSpec.describe SubmissionScore do
  describe "regioning" do
    it "works with primary region searches" do
      FactoryBot.create(:submission_score, :los_angeles)
      chi = FactoryBot.create(:submission_score, :chicago)
      chapter_ambassador = FactoryBot.create(:ambassador, :chicago)

      expect(SubmissionScore.in_region(chapter_ambassador)).to contain_exactly(chi)
    end

    it "works with secondary region searches" do
      FactoryBot.create(:submission_score, :brazil)
      la = FactoryBot.create(:submission_score, :los_angeles)
      chi = FactoryBot.create(:submission_score, :chicago)

      chapter_ambassador = FactoryBot.create(
        :ambassador,
        :chicago,
        secondary_regions: ["CA, US"])

      expect(SubmissionScore.in_region(chapter_ambassador)).to contain_exactly(chi, la)
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

      project_details_1: 5,
      ideation_1: 5,
      pitch_1: 5,
      demo_1: 5,
      entrepreneurship_1: 5
    })

    expect(subscore.total).to eq(25)
  end

  it "calculates section totals" do
    team = Team.create!(name: "A", description: "B", division: Division.senior)
    team_submission = TeamSubmission.create!(
      team_id: team.id,
      integrity_affirmed: true
    )
    judge_profile = FactoryBot.create(:judge_profile)

    subscore = SubmissionScore.create!({
      team_submission: team_submission,
      judge_profile: judge_profile,

      ideation_1: 5,
      ideation_2: 2,
      ideation_3: 1,
      ideation_4: 3,

      technical_1: 4,
      technical_2: 3,
      technical_3: 3,
      technical_4: 2,

      pitch_1: 3,
      pitch_2: 5,

      entrepreneurship_1: 5,
      entrepreneurship_2: 4,
      entrepreneurship_3: 5,
      entrepreneurship_4: 3,

      overall_1: 3,
      overall_2: 2,
    })

    expect(subscore.ideation_total).to eq(11)
    expect(subscore.technical_total).to eq(12)
    expect(subscore.pitch_total).to eq(8)
    expect(subscore.entrepreneurship_total).to eq(17)
    expect(subscore.overall_total).to eq(5)
  end

  describe ".total_possible_score_for" do
    let(:total_score_possible) {
      SubmissionScore.total_possible_score_for(division: division, season: season)
    }

    context "when it's the senior division in the 2022 season" do
      let(:division) { "senior" }
      let(:season) { 2022 }

      it "returns 90" do
        expect(total_score_possible).to eq(90)
      end
    end

    context "when it's the junior division in the 2022 season" do
      let(:division) { "junior" }
      let(:season) { 2022 }

      it "returns 90" do
        expect(total_score_possible).to eq(80)
      end
    end

    context "when it's the beginner division in the 2022 season" do
      let(:division) { "beginner" }
      let(:season) { 2022 }

      it "returns 90" do
        expect(total_score_possible).to eq(39)
      end
    end
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
          ideation_1: 5,
          round: round,
        )

        sub.complete!
        expect(
          team_submission.reload.public_send("#{judging_round}_average_score")
        ).to eq(5)

        sub.update(ideation_1: 4)
        expect(
          team_submission.reload.public_send("#{judging_round}_average_score")
        ).to eq(4)

        judge_profile2 = FactoryBot.create(:judge_profile)

        sub2 = SubmissionScore.create!(
          judge_profile_id: judge_profile2.id,
          team_submission_id: team_submission.id,
          ideation_1: 2,
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
          ideation_1: 5,
          round: round,
        )
        expect(
          team_submission.reload.public_send("#{judging_round}_average_score")
        ).to be_zero
      end

      context "deleting and restoring a score" do
        let(:team_submission) { FactoryBot.create(:team_submission) }
        let(:judge_judy) { FactoryBot.create(:judge_profile) }

        let!(:high_score_submission_from_random_judge) {
          SubmissionScore.create!(
            judge_profile_id: FactoryBot.create(:judge_profile).id,
            team_submission_id: team_submission.id,
            ideation_1: 10,
            round: round,
            completed_at: Time.current)
        }
        let!(:low_score_submission_from_random_judge) {
          SubmissionScore.create!(
            judge_profile_id: FactoryBot.create(:judge_profile).id,
            team_submission_id: team_submission.id,
            ideation_1: 5,
            round: round,
            completed_at: Time.current)
        }
        let!(:bad_score_submission_from_judge_judy) {
          SubmissionScore.create!(
            judge_profile_id: judge_judy.id,
            team_submission_id: team_submission.id,
            ideation_1: 20,
            round: round,
            completed_at: Time.current)
        }
        let!(:another_score_submission_from_judge_judy_for_another_team) {
          SubmissionScore.create!(
            judge_profile_id: judge_judy.id,
            team_submission_id: FactoryBot.create(:team_submission).id,
            ideation_1: 15,
            round: round,
            completed_at: Time.current)
        }

        describe "deleting a score" do
          context "when judge judy's bad score sumission is deleted" do
            before do
              bad_score_submission_from_judge_judy.destroy

              team_submission.reload
            end

            it "updates the team's total number of completed scores" do
              expect(team_submission.
                public_send("complete_#{judging_round}_submission_scores_count")).to eq(2)
            end

            it "updates the team's total number of offical completed scores" do
              expect(team_submission.
                public_send("complete_#{judging_round}_official_submission_scores_count")).to eq(2)
            end

            it "recalculates the team's average score" do
              expect(team_submission.
                public_send("#{judging_round}_average_score")).to eq(7.5)
            end

            it "recalculates the team's score range (high score minus the low score)" do
              expect(team_submission.
                public_send("#{judging_round}_score_range")).to eq(5)
            end

            it "updates judy's total number of scored submissions" do
              judge_judy.reload

              expect(judge_judy.
                public_send("#{judging_round}_scores_count")).to eq(1)
            end
          end
        end

        describe "restoring a score" do
          context "when judge judy's bad score sumission is deleted and then restored" do
            before do
              bad_score_submission_from_judge_judy.destroy
              bad_score_submission_from_judge_judy.restore

              team_submission.reload
            end

            it "updates the team's total number of completed scores" do
              expect(team_submission.
                public_send("complete_#{judging_round}_submission_scores_count")).to eq(3)
            end

            it "updates the team's total number of offical completed scores" do
              expect(team_submission.
                public_send("complete_#{judging_round}_official_submission_scores_count")).to eq(3)
            end

            it "recalculates the team's average score" do
              expect(team_submission.
                public_send("#{judging_round}_average_score")).to eq(11.67)
            end

            it "recalculates the team's score range (high score minus the low score)" do
              expect(team_submission.
                public_send("#{judging_round}_score_range")).to eq(15)
            end

            it "updates judy's total number of scored submissions" do
              judge_judy.reload

              expect(judge_judy.
                public_send("#{judging_round}_scores_count")).to eq(2)
            end
          end

          context "when judge judy's bad score sumission is dropped and then restored" do
            before do
              bad_score_submission_from_judge_judy.drop_score!
              bad_score_submission_from_judge_judy.restore

              team_submission.reload
            end

            it "resets the dropped status" do
              expect(bad_score_submission_from_judge_judy).not_to be_dropped
            end
          end
        end
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

  describe "scopes" do
    let(:not_started_score) { FactoryBot.create(:score, :not_started) }
    let(:in_progress_score) { FactoryBot.create(:score, :in_progress) }
    let(:finished_score) { FactoryBot.create(:score, :complete) }

    describe ".not_started" do
      it "includes scores that haven't been started yet" do
        expect(SubmissionScore.not_started).to include(not_started_score)
      end

      it "des not include scores that are in progress" do
        expect(SubmissionScore.not_started).not_to include(in_progress_score)
      end

      it "does not include finished scores" do
        expect(SubmissionScore.not_started).not_to include(finished_score)
      end
    end

    describe ".in_progress" do
      it "includes scores that are in progress" do
        expect(SubmissionScore.in_progress).to include(in_progress_score)
      end

      it "does not include scores that haven't been started yet" do
        expect(SubmissionScore.in_progress).not_to include(not_started_score)
      end

      it "does not include finished scores" do
        expect(SubmissionScore.in_progress).not_to include(finished_score)
      end
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

  describe "#pending_approval?" do
    let(:score_submission) {
      FactoryBot.build_stubbed(:score,
       completed_at: completed_at,
       approved_at: approved_at)
    }

    context "when the score submission is complete" do
      let(:completed_at) { Time.current }

      context "when the score submission is not approved" do
        let(:approved_at) { nil }

        it "returns true" do
          expect(score_submission.pending_approval?).to be true
        end
      end

      context "when the score submission is approved" do
        let(:approved_at) { Time.current }

        it "returns false" do
          expect(score_submission.pending_approval?).to be false
        end
      end
    end

    context "when the score submission is incomplete" do
      let(:completed_at) { nil }

      context "when the score submission is not approved" do
        let(:approved_at) { nil }

        it "returns false" do
          expect(score_submission.pending_approval?).to be false
        end
      end

      context "when the score submission is approved" do
        let(:approved_at) { Time.current }

        it "returns false" do
          expect(score_submission.pending_approval?).to be false
        end
      end
    end
  end

  describe ".judge_not_deleted" do
    let(:score_with_deleted_judge) {
      score = FactoryBot.create(:score)
      score.judge_profile.account.destroy
      score
    }

    let(:score_with_judge) {
      FactoryBot.create(:score)
    }

    it "filters scores where the judge has been deleted" do
      expect(SubmissionScore.judge_not_deleted).not_to include(score_with_deleted_judge)
    end

    it "includes scores with judges" do
      expect(SubmissionScore.judge_not_deleted).to include(score_with_judge)
    end
  end

  describe ".total_possible_points_for_section" do
    before do
      allow(JudgeQuestions)
        .to receive(:new)
        .with(division: division, season: season)
        .and_return(judge_questions_instance)
    end

    let(:division) { "senior" }
    let(:season) { 2022 }
    let(:section) { "demo" }
    let(:judge_questions_instance) { instance_double(JudgeQuestions, call: judge_questions) }
    let(:judge_questions) do
      [
        instance_double(Question, idx: 1, section: "demo", worth: 5, submission_type: "A"),
        instance_double(Question, idx: 1, section: "demo", worth: 5, submission_type: "B"),
        instance_double(Question, idx: 2, section: "demo", worth: 5),
        instance_double(Question, idx: 3, section: "demo", worth: 5),
        instance_double(Question, idx: 3, section: "not demo", worth: 5)
      ]
    end

    it "returns the total points for a given section and for unique idx values" do
      expect(
        SubmissionScore.total_possible_points_for_section(
          section: section,
          division: division,
          season: season
        )
      ).to equal(15)
    end
  end
end
