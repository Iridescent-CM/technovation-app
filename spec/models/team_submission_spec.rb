require "rails_helper"

RSpec.describe TeamSubmission do
  before { SeasonToggles.team_submissions_editable! }

  it "validates the app inventor app name" do
    submission = FactoryBot.create(:submission, :complete)

    submission.app_inventor_app_name = "spaces in the string"
    expect(submission).not_to be_valid

    submission.app_inventor_app_name = "symbols&=%inthestring"
    expect(submission).not_to be_valid

    submission.app_inventor_app_name = "hyphens-in-the-string"
    expect(submission).not_to be_valid

    submission.app_inventor_app_name = "nospacesinthe_string_and_CAPITALS_and_nums_123"
    expect(submission).to be_valid
  end

  it "validates the thunkable URL" do
    submission = FactoryBot.create(:submission, :complete)

    submission.thunkable_project_url = "https://google.com"
    expect(submission).not_to be_valid

    submission.thunkable_project_url = "https://thunkable.com"
    expect(submission).not_to be_valid

    submission.thunkable_project_url = "https://thunkable.com/something"
    expect(submission).not_to be_valid

    submission.thunkable_project_url = "https://x.thunkable.com/not-copy/something"
    expect(submission).not_to be_valid

    submission.thunkable_project_url = "https://not-an-x.thunkable.com/copy/abc123"
    expect(submission).not_to be_valid

    submission.thunkable_project_url = "http://x.thunkable.com/copy/abc123"
    expect(submission).to be_valid
    expect(submission.thunkable_project_url).to eq("https://x.thunkable.com/copy/abc123")

    submission.thunkable_project_url = "x.thunkable.com/copy/abc123"
    expect(submission).to be_valid
    expect(submission.thunkable_project_url).to eq("https://x.thunkable.com/copy/abc123")

    submission.thunkable_project_url = "https://x.thunkable.com/copy/47d800b3aa47590210ad662249e63dd4"
    expect(submission).to be_valid
    expect(submission.thunkable_project_url).to eq("https://x.thunkable.com/copy/47d800b3aa47590210ad662249e63dd4")
  end

  describe "ACTIVE_DEVELOPMENT_PLATFORMS_ENUM" do
    it "returns a list of active development platforms (in Rails enum format)" do
      expect(TeamSubmission::ACTIVE_DEVELOPMENT_PLATFORMS_ENUM).to eq({
        "App Inventor" => 0,
        "Thunkable" => 6,
        "Java or Android Studio" => 2,
        "Swift or XCode" => 1
      })
    end
  end

  describe "INACTIVE_DEVELOPMENT_PLATFORMS_ENUM" do
    it "returns a list of inactive development platforms (in Rails enum format)" do
      expect(TeamSubmission::INACTIVE_DEVELOPMENT_PLATFORMS_ENUM).to eq({
        "C++" => 3,
        "PhoneGap/Apache Cordova" => 4,
        "Other" => 5,
        "Thunkable Classic" => 7
      })
    end
  end

  describe "ALL_DEVELOPMENT_PLATFORMS_ENUM" do
    it "returns a list of all (active and invactive) development platforms (in Rails enum format)" do
      expect(TeamSubmission::ALL_DEVELOPMENT_PLATFORMS_ENUM).to eq({
        "App Inventor" => 0,
        "Thunkable" => 6,
        "Java or Android Studio" => 2,
        "Swift or XCode" => 1,
        "C++" => 3,
        "PhoneGap/Apache Cordova" => 4,
        "Other" => 5,
        "Thunkable Classic" => 7
      })
    end
  end

  describe "DEVELOPMENT_PLATFORMS" do
    it "returns a list of (active) development platforms" do
      expect(TeamSubmission::DEVELOPMENT_PLATFORMS).to eq([
        "App Inventor",
        "Thunkable",
        "Java or Android Studio",
        "Swift or XCode"
      ])
    end
  end

  describe "#developed_on?(platform_name)" do
    it "matches exact names" do
      submission = FactoryBot.create(:submission, :complete)

      submission.development_platform = "Swift or XCode"
      expect(submission.developed_on?("Swift or XCode")).to be true

      submission.development_platform = "Thunkable Classic"
      expect(submission.developed_on?("Thunkable Classic")).to be true

      submission.development_platform = "Thunkable"
      expect(submission.developed_on?("Thunkable")).to be true
    end
  end

  it "removes existing current round scores if unpublished" do
    SeasonToggles.set_judging_round(:qf)

    submission = FactoryBot.create(:submission, :complete)
    FactoryBot.create(:score, team_submission: submission)

    expect {
      submission.published_at = nil
      submission.save
    }
      .to change { submission.scores.current_round.count }
      .from(1).to(0)

    SeasonToggles.set_judging_round(:off)
  end

  describe "regioning" do
    it "works with primary region searches" do
      la_team = FactoryBot.create(:team, :los_angeles)
      FactoryBot.create(:submission, team: la_team)

      chi_team = FactoryBot.create(:team, :chicago)
      chi = FactoryBot.create(:submission, team: chi_team)

      chapter_ambassador = FactoryBot.create(:ambassador, :chicago)

      expect(TeamSubmission.in_region(chapter_ambassador)).to contain_exactly(chi)
    end

    it "works with secondary region searches" do
      br_team = FactoryBot.create(:team, :brazil)
      FactoryBot.create(:submission, team: br_team)

      la_team = FactoryBot.create(:team, :los_angeles)
      la = FactoryBot.create(:submission, team: la_team)

      chi_team = FactoryBot.create(:team, :chicago)
      chi = FactoryBot.create(:submission, team: chi_team)

      chapter_ambassador = FactoryBot.create(
        :ambassador,
        :chicago,
        secondary_regions: ["CA, US"]
      )

      expect(TeamSubmission.in_region(chapter_ambassador)).to contain_exactly(chi, la)
    end
  end

  describe "#percent_complete" do
    context "when a junior team is submitting" do
      it "returns 0% when no items have been completed" do
        junior_submission = FactoryBot.create(:submission, :junior)

        expect(junior_submission.percent_complete).to eq(0)
      end

      it "returns 14% when one item has been completed" do
        junior_submission = FactoryBot.create(:submission, :junior)

        junior_submission.update(app_name: "An amazing app")

        expect(junior_submission.percent_complete).to eq(14)
      end

      it "returns 86% when all items have been completed but it hasn't been published yet" do
        junior_submission = FactoryBot.create(:submission, :junior, :complete)

        junior_submission.update(published_at: nil)

        expect(junior_submission.percent_complete).to eq(86)
      end

      it "returns 100% when all items have bene completed and it has been published" do
        junior_submission = FactoryBot.create(:submission, :junior, :complete)

        junior_submission.publish!

        expect(junior_submission.percent_complete).to eq(100)
      end
    end

    context "when a senior team is submitting" do
      it "returns 0% when no items have been completed" do
        senior_submission = FactoryBot.create(:submission, :senior)

        expect(senior_submission.percent_complete).to eq(0)
      end

      it "returns 13% when one item has been completed" do
        senior_submission = FactoryBot.create(:submission, :senior)

        senior_submission.update(app_name: "Fantastico Magnifico")

        expect(senior_submission.percent_complete).to eq(13)
      end

      it "returns 88% when all items have been completed but it hasn't been published yet" do
        senior_submission = FactoryBot.create(:submission, :senior, :complete)

        senior_submission.update(published_at: nil)

        expect(senior_submission.percent_complete).to eq(88)
      end

      it "returns 100% when all items have bene completed and it has been published" do
        senior_submission = FactoryBot.create(:submission, :senior, :complete)

        senior_submission.publish!

        expect(senior_submission.percent_complete).to eq(100)
      end
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

  describe "quarterfinals scores" do
    before(:each) { SeasonToggles.set_judging_round(:qf) }
    after(:each) { SeasonToggles.clear_judging_round }

    let(:team) { FactoryBot.create(:team, :junior) }
    let(:sub) { FactoryBot.create(:submission, :complete, team: team) }
    let(:live_judge) { FactoryBot.create(:judge_profile) }
    let(:virtual_judge) { FactoryBot.create(:judge_profile) }

    describe "for offical RPE" do
      before(:each) do
        @rpe = FactoryBot.create(:event,
          name: "RPE",
          starts_at: Date.today,
          ends_at: Date.today + 1.day,
          division_ids: Division.senior.id,
          city: "City",
          venue_address: "123 Street St.",
          unofficial: false)

        team.regional_pitch_events << @rpe
        team.save

        live_judge.regional_pitch_events << @rpe
        live_judge.save
      end

      it "counts live scores as official" do
        live_score = live_judge.submission_scores.create!({
          team_submission: sub,
          ideation_1: 5,
          completed_at: Time.current
        })

        virtual_score = virtual_judge.submission_scores.create!({
          team_submission: sub,
          ideation_1: 2,
          completed_at: Time.current
        })

        expect(sub.reload.quarterfinals_official_scores).to contain_exactly(live_score)
        expect(sub.reload.quarterfinals_unofficial_scores).to contain_exactly(virtual_score)
      end

      it "averages official and unofficial scores" do
        [6, 4].each do |score|
          live_judge = FactoryBot.create(:judge_profile)
          live_judge.regional_pitch_events << @rpe
          live_judge.save

          live_judge.submission_scores.create!({
            team_submission: sub,
            ideation_1: score,
            completed_at: Time.current
          })
        end

        [4, 2].each do |score|
          virtual_judge = FactoryBot.create(:judge_profile)
          virtual_judge.submission_scores.create!({
            team_submission: sub,
            ideation_1: score,
            completed_at: Time.current
          })
        end

        expect(sub.reload.quarterfinals_average_score).to eq(5)
        expect(sub.reload.average_unofficial_score).to eq(3)
      end

      it "computes range of official scores" do
        [1, 6, 10].each do |score|
          live_judge = FactoryBot.create(:judge_profile)
          live_judge.regional_pitch_events << @rpe
          live_judge.save

          live_judge.submission_scores.create!({
            team_submission: sub,
            ideation_1: score,
            completed_at: Time.current
          })
        end

        [11].each do |score|
          virtual_judge = FactoryBot.create(:judge_profile)
          virtual_judge.submission_scores.create!({
            team_submission: sub,
            ideation_1: score,
            completed_at: Time.current
          })
        end

        expect(sub.reload.quarterfinals_score_range).to eq(9)
      end
    end

    describe "for unoffical RPE" do
      before(:each) do
        @rpe = FactoryBot.create(:event,
          name: "RPE",
          starts_at: Date.today,
          ends_at: Date.today + 1.day,
          division_ids: Division.senior.id,
          city: "City",
          venue_address: "123 Street St.",
          unofficial: true)

        team.regional_pitch_events << @rpe
        team.save

        live_judge.regional_pitch_events << @rpe
        live_judge.save
      end

      it "counts virtual scores as official" do
        live_score = live_judge.submission_scores.create!({
          team_submission: sub,
          ideation_1: 5,
          completed_at: Time.current
        })

        virtual_score = virtual_judge.submission_scores.create!({
          team_submission: sub,
          ideation_1: 2,
          completed_at: Time.current
        })

        expect(sub.reload.quarterfinals_official_scores).to contain_exactly(virtual_score)
        expect(sub.reload.quarterfinals_unofficial_scores).to contain_exactly(live_score)
      end

      it "averages official and unofficial scores" do
        [6, 4].each do |score|
          live_judge = FactoryBot.create(:judge_profile)
          live_judge.regional_pitch_events << @rpe
          live_judge.save

          live_judge.submission_scores.create!({
            team_submission: sub,
            ideation_1: score,
            completed_at: Time.current
          })
        end

        [4, 2].each do |score|
          virtual_judge = FactoryBot.create(:judge_profile)
          virtual_judge.submission_scores.create!({
            team_submission: sub,
            ideation_1: score,
            completed_at: Time.current
          })
        end

        expect(sub.reload.quarterfinals_average_score).to eq(3)
        expect(sub.reload.average_unofficial_score).to eq(5)
      end

      it "computes range of official scores" do
        [11].each do |score|
          live_judge = FactoryBot.create(:judge_profile)
          live_judge.regional_pitch_events << @rpe
          live_judge.save

          live_judge.submission_scores.create!({
            team_submission: sub,
            ideation_1: score,
            completed_at: Time.current
          })
        end

        [1, 6, 10].each do |score|
          virtual_judge = FactoryBot.create(:judge_profile)
          virtual_judge.submission_scores.create!({
            team_submission: sub,
            ideation_1: score,
            completed_at: Time.current
          })
        end

        expect(sub.reload.quarterfinals_score_range).to eq(9)
      end
    end

    describe "for virtual team" do
      it "counts virtual scores as official" do
        virtual_score = virtual_judge.submission_scores.create!({
          team_submission: sub,
          ideation_1: 2,
          completed_at: Time.current
        })

        expect(sub.reload.quarterfinals_official_scores).to contain_exactly(virtual_score)
        expect(sub.reload.quarterfinals_unofficial_scores).to be_empty
      end

      it "averages official scores" do
        [4, 2].each do |score|
          virtual_judge = FactoryBot.create(:judge_profile)
          virtual_judge.submission_scores.create!({
            team_submission: sub,
            ideation_1: score,
            completed_at: Time.current
          })
        end

        expect(sub.reload.quarterfinals_average_score).to eq(3)
        expect(sub.reload.average_unofficial_score).to eq(0)
      end

      it "computes range of official scores" do
        [1, 6, 10].each do |score|
          virtual_judge = FactoryBot.create(:judge_profile)
          virtual_judge.submission_scores.create!({
            team_submission: sub,
            ideation_1: score,
            completed_at: Time.current
          })
        end

        expect(sub.reload.quarterfinals_score_range).to eq(9)
      end
    end
  end

  describe "semifinals scores" do
    before(:each) { SeasonToggles.set_judging_round(:sf) }
    after(:each) { SeasonToggles.clear_judging_round }

    let(:team) { FactoryBot.create(:team, :junior) }
    let(:sub) { FactoryBot.create(:submission, :complete, team: team) }

    it "averages scores" do
      [3, 6].each do |score|
        judge = FactoryBot.create(:judge_profile)
        judge.submission_scores.create!({
          team_submission: sub,
          ideation_1: score,
          completed_at: Time.current,
          round: :semifinals
        })
      end

      expect(sub.reload.semifinals_average_score).to eq(4.5)
    end

    it "computes ranges of scores" do
      [3, 6, 10].each do |score|
        judge = FactoryBot.create(:judge_profile)
        judge.submission_scores.create!({
          team_submission: sub,
          ideation_1: score,
          completed_at: Time.current,
          round: :semifinals
        })
      end

      expect(sub.reload.semifinals_score_range).to eq(7)
    end
  end
end
