require "rails_helper"

RSpec.describe TeamSubmission do
  describe "#percent_complete" do
    it "returns 0 for nothing completed" do
      submission = FactoryBot.create(:submission)
      expect(submission.percent_complete).to eq(0)
    end

    it "returns 14 for one junior team item completed" do
      submission = FactoryBot.create(:submission)
      submission.update(app_name: "Something")
      expect(submission.percent_complete).to eq(14)
    end

    it "returns 13 for one senior team item completed" do
      submission = FactoryBot.create(:submission, :senior)
      submission.update(app_name: "Something")
      expect(submission.percent_complete).to eq(13)
    end

    it "returns 100 percent for all of the items completed" do
      submission = FactoryBot.create(:submission, :junior, :complete)

      # TODO: faking the source code url
      expect(submission).to receive(:source_code_url)
        .and_return("something")

      expect(submission.percent_complete).to eq(100)
    end
  end

  it "can be #complete?" do
    team = FactoryBot.create(:team)
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
    team = FactoryBot.create(:team)
    sub = FactoryBot.create(:submission, :complete, team: team)

    live_judge = FactoryBot.create(:judge_profile)
    virtual_judge = FactoryBot.create(:judge_profile)


    rpe = RegionalPitchEvent.create!({
      regional_ambassador_profile: FactoryBot.create(
        :regional_ambassador_profile
      ),
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
