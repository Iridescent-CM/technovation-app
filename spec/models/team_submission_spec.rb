require "rails_helper"

RSpec.describe TeamSubmission do
  before { SeasonToggles.team_submissions_editable! }

  describe "regioning" do
    it "works with primary region searches" do
      la_team = FactoryBot.create(:team, :los_angeles)
      FactoryBot.create(:submission, team: la_team)

      chi_team = FactoryBot.create(:team, :chicago)
      chi = FactoryBot.create(:submission, team: chi_team)

      ra = FactoryBot.create(:ambassador, :chicago)

      expect(TeamSubmission.in_region(ra)).to contain_exactly(chi)
    end

    it "works with secondary region searches" do
      br_team = FactoryBot.create(:team, :brazil)
      FactoryBot.create(:submission, team: br_team)

      la_team = FactoryBot.create(:team, :los_angeles)
      la = FactoryBot.create(:submission, team: la_team)

      chi_team = FactoryBot.create(:team, :chicago)
      chi = FactoryBot.create(:submission, team: chi_team)

      ra = FactoryBot.create(
        :ambassador,
        :chicago,
        secondary_regions: ["CA, US"])

      expect(TeamSubmission.in_region(ra)).to contain_exactly(chi, la)
    end
  end

  describe "#percent_complete" do
    it "returns 0 for nothing completed" do
      submission = FactoryBot.create(:submission, :junior)
      expect(submission.percent_complete).to eq(0)
    end

    it "returns 14 for one junior team item completed" do
      submission = FactoryBot.create(:submission, :junior)
      submission.update(app_name: "Something")
      expect(submission.percent_complete).to eq(14)
    end

    it "returns 13 for one senior team item completed" do
      submission = FactoryBot.create(:submission, :senior)
      submission.update(app_name: "Something")
      expect(submission.reload.percent_complete).to eq(13)
    end

    it "returns 100 percent for all of the items completed" do
      submission = FactoryBot.create(:submission, :junior, :complete)

      submission.update_column(:source_code, "something.zip")
      submission.touch
      expect(submission.reload.percent_complete).to eq(100)
    end
  end

  it "can be #complete?" do
    team = FactoryBot.create(:team, :junior)
    sub = FactoryBot.create(:submission, :complete, team: team)

    expect(sub.reload).to be_complete

    RequiredFields.new(sub).each do |field|
      if field.method_name == :screenshots
        sub.screenshots.destroy_all
      elsif field.method_name == :development_platform_text
        sub.update(development_platform: nil)
      elsif field.method_name == :source_code_url
        sub.remove_source_code!
      else
        sub.update(field.method_name => nil)
      end

      expect(sub.reload).not_to be_complete,
        "failed method: #{field.method_name}"
    end
  end

  it "only averages scores that count" do
    team = FactoryBot.create(:team, :junior)
    sub = FactoryBot.create(:submission, :complete, team: team)

    live_judge = FactoryBot.create(:judge_profile)
    virtual_judge = FactoryBot.create(:judge_profile)


    rpe = FactoryBot.create(:event,
      name: "RPE",
      starts_at: Date.today,
      ends_at: Date.today + 1.day,
      division_ids: Division.senior.id,
      city: "City",
      venue_address: "123 Street St.",
      unofficial: true,
    )

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
