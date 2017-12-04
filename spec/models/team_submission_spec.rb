require "rails_helper"

RSpec.describe TeamSubmission do
  subject { TeamSubmission.new }

  it { should respond_to(:app_name) }
  it { should respond_to(:demo_video_link) }
  it { should respond_to(:pitch_video_link) }

  describe "cache_key" do

    subject(:submission) {
      TeamSubmission.create!({
        integrity_affirmed: true,
        team: FactoryBot.create(:team)
      })
    }

    before(:each) do
      @before_key = submission.cache_key
    end

    it "changes when screenshot added" do
      submission.screenshots.create!
      expect(submission.cache_key).not_to eq(@before_key)
    end

    it "changes when business plan added" do
      BusinessPlan.create!({
        team_submission: submission
      })
      expect(submission.cache_key).not_to eq(@before_key)
    end

    it "changes when pitch presentation added" do
      PitchPresentation.create!({
        team_submission: submission
      })
      expect(submission.cache_key).not_to eq(@before_key)
    end

    it "changes when technical checklist added" do
      FactoryBot.create(
        :technical_checklist,
        :completed,
        team_submission: submission
      )
      expect(submission.cache_key).not_to eq(@before_key)
    end

    it "changes when team division changes" do
      team = submission.team
      TeamRosterManaging.remove(team, team.students.first)
      expect(submission.reload.cache_key).not_to eq(@before_key)
    end

    it "changes when team regional pitch event changes" do
      team = submission.team
      team.reload
      team.regional_pitch_events << RegionalPitchEvent.create!({
        regional_ambassador_profile: FactoryBot.create(
          :regional_ambassador_profile
        ),
        name: "RPE",
        starts_at: Date.today,
        ends_at: Date.today + 1.day,
        division_ids: Division.senior.id,
        city: "City",
        venue_address: "123 Street St."
      })
      expect(submission.reload.cache_key).not_to eq(@before_key)
    end

  end

  it "can be #complete?" do
    team = FactoryBot.create(:team)
    sub = FactoryBot.create(:submission, :complete, team: team)
    expect(sub.reload.complete?).to be true
  end

  it "only averages scores that count" do
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
      unofficial: true,
    })

    team.regional_pitch_events << rpe
    team.save

    live_judge.regional_pitch_events << rpe
    live_judge.save

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

    expect(sub.reload.quarterfinals_average_score).to eq(2)

    expect(sub.reload.average_unofficial_score).to eq(5)
  end
end
