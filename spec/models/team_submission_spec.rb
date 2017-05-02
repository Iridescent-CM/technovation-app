require "rails_helper"

RSpec.describe TeamSubmission do
  subject { TeamSubmission.new }

  it { should respond_to(:app_name) }
  it { should respond_to(:demo_video_link) }
  it { should respond_to(:pitch_video_link) }
  it { should respond_to(:stated_goal) }
  it { should respond_to(:stated_goal_explanation) }

  it "has a defined list of Sustainabel Development Goals (SDG)" do
    goals = TeamSubmission.stated_goals.keys

    expect(goals).to match_array(
      %w{Poverty Environment Peace Equality Education Health}
    )
  end

  it "prepends urls with http:// if it's not there" do
    subject.source_code_external_url = "joesak.com"
    expect(subject.source_code_external_url).to eq("http://joesak.com")

    subject.source_code_external_url = "http://joesak.com"
    expect(subject.source_code_external_url).to eq("http://joesak.com")

    subject.source_code_external_url = "https://joesak.com"
    expect(subject.source_code_external_url).to eq("https://joesak.com")

    subject.source_code_external_url = "ht://joesak.com"
    expect(subject.source_code_external_url).to eq("http://joesak.com")

    subject.source_code_external_url = ""
    expect(subject.source_code_external_url).to be_blank
  end

  describe "cache_key" do

    subject(:submission) {
      TeamSubmission.create!({
        integrity_affirmed: true,
        team: FactoryGirl.create(:team)
      })
    }

    before(:each) do
      @before_key = submission.cache_key
    end

    it "changes when RPE toggles unofficial" do
      rpe = RegionalPitchEvent.create!({
        name: "hey",
        city: "okay",
        venue_address: "what",
        starts_at: Time.current,
        ends_at: Time.current,
        division_ids: Division.junior.id,
      })
      rpe.teams << submission.team
      rpe.save!

      my_cache_key = submission.cache_key

      rpe.unofficial!

      expect(submission.reload.cache_key).not_to eq(@before_key)
      expect(submission.reload.cache_key).not_to eq(my_cache_key)
    end

    it "changes when screenshot added" do
      screenshot = Screenshot.create!()
      screenshot.update_column(:image, "/img/screenshot.png")
      submission.screenshots << screenshot
      expect(submission.cache_key).not_to eq(@before_key)
    end

    it "changes when business plan added" do
      BusinessPlan.create!({
        remote_file_url: "http://example.org/businessplan",
        team_submission: submission
      })
      expect(submission.cache_key).not_to eq(@before_key)
    end

    it "changes when pitch presentation added" do
      PitchPresentation.create!({
        remote_file_url: "http://example.org/pitch",
        team_submission: submission
      })
      expect(submission.cache_key).not_to eq(@before_key)
    end

    it "changes when technical checklist added" do
      FactoryGirl.create(:technical_checklist, :completed, team_submission: submission)
      expect(submission.cache_key).not_to eq(@before_key)
    end

    it "changes when team photo changes" do
      team = submission.team
      team.team_photo = Rack::Test::UploadedFile.new(File.join(
        Rails.root, 'spec', 'support', 'imgs', 'natasha-avatar.jpg'), 'image/jpg')
      team.save
      expect(submission.reload.cache_key).not_to eq(@before_key)
    end

    it "changes when team division changes" do
      team = submission.team
      team.remove_student(team.students.first)
      expect(submission.reload.cache_key).not_to eq(@before_key)
    end

    it "changes when team regional pitch event changes" do
      team = submission.team
      team.regional_pitch_events << RegionalPitchEvent.create!({
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
    team = FactoryGirl.create(:team)
    team.update_column(:team_photo, "/foo/bar/img.png")
    sub = FactoryGirl.create(:submission, :complete, team: team)
    expect(sub.reload.complete?).to be true
  end

  it "only averages scores that count" do
    team = FactoryGirl.create(:team)
    sub = FactoryGirl.create(:submission, :complete, team: team)

    live_judge = FactoryGirl.create(:judge_profile)
    virtual_judge = FactoryGirl.create(:judge_profile)


    rpe = RegionalPitchEvent.create!({
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
      sdg_alignment: 5,
      completed_at: Time.current
    })

    virtual_judge.submission_scores.create!({
      team_submission: sub,
      sdg_alignment: 2,
      completed_at: Time.current
    })

    expect(sub.reload.average_score).to eq(2)

    expect(sub.reload.average_unofficial_score).to eq(5)
  end
end
