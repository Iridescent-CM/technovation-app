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

    submission.thunkable_project_url = "https://x.thunkable.com/not-projects/something"
    expect(submission).not_to be_valid

    submission.thunkable_project_url = "https://not-an-x.thunkable.com/projectPage/abc123"
    expect(submission).not_to be_valid

    submission.thunkable_project_url = "http://x.thunkable.com/projectPage/abc123"
    expect(submission).to be_valid
    expect(submission.thunkable_project_url).to eq("https://x.thunkable.com/projectPage/abc123")

    submission.thunkable_project_url = "x.thunkable.com/projectPage/abc123"
    expect(submission).to be_valid
    expect(submission.thunkable_project_url).to eq("https://x.thunkable.com/projectPage/abc123")

    submission.thunkable_project_url = "https://x.thunkable.com/projectPage/47d800b3aa47590210ad662249e63dd4"
    expect(submission).to be_valid
    expect(submission.thunkable_project_url).to eq("https://x.thunkable.com/projectPage/47d800b3aa47590210ad662249e63dd4")
  end

  it "validates the scratch URL" do
    submission = FactoryBot.create(:submission, :complete)

    submission.scratch_project_url = "https://google.com"
    expect(submission).not_to be_valid

    submission.scratch_project_url = "https://scratch.com"
    expect(submission).not_to be_valid

    submission.scratch_project_url = "https://scratch.com/something"
    expect(submission).not_to be_valid

    submission.scratch_project_url = "https://scratch.com/not-projects/something"
    expect(submission).not_to be_valid

    submission.scratch_project_url = "https://scratch.mit.edu/projects/12345"
    expect(submission).to be_valid
    expect(submission.scratch_project_url).to eq("https://scratch.mit.edu/projects/12345")
  end

  it "validates the code.org app lab URL" do
    submission = FactoryBot.create(:submission, :complete)

    submission.code_org_app_lab_project_url = "https://google.com"
    expect(submission).not_to be_valid

    submission.code_org_app_lab_project_url = "https://studio.code.org"
    expect(submission).not_to be_valid

    submission.code_org_app_lab_project_url = "https://studio.code.org/something"
    expect(submission).not_to be_valid

    submission.code_org_app_lab_project_url = "https://studio.code.org/not-projects/something"
    expect(submission).not_to be_valid

    submission.code_org_app_lab_project_url = "https://studio.code.org/projects/applab/12345"
    expect(submission).to be_valid
    expect(submission.code_org_app_lab_project_url).to eq("https://studio.code.org/projects/applab/12345")
  end

  it "is invalid if the team does not have at least one student" do
    team = FactoryBot.create(:team, members_count: 0)
    submission = FactoryBot.build(:submission, team: team)
    expect(submission).not_to be_valid
  end

  it "is valid when the team has at least one student" do
    team = FactoryBot.create(:team, members_count: 2)
    submission = FactoryBot.build(:submission, team: team)
    expect(submission).to be_valid
  end

  context "callbacks" do
    let(:submission) { FactoryBot.create(:submission) }

    describe "#after_commit" do
      context "when there are students on the team" do
        let(:student) { FactoryBot.create(:student) }

        before do
          TeamRosterManaging.add(submission.team, student)
        end

        context "when CRM fields are being updated" do
          context "when the app name is being updated" do
            it "calls the job to update the student's program info" do
              expect(CRM::UpsertProgramInfoJob).to receive(:perform_later)

              submission.update(
                app_name: "My updated app name"
              )
            end
          end

          context "when the pitch link is being updated" do
            it "calls the job to update the student's program info" do
              expect(CRM::UpsertProgramInfoJob).to receive(:perform_later)

              submission.update(
                pitch_video_link: "http://example.com/xzy-pitch-video"
              )
            end
          end

          context "when the submission is being published" do
            it "calls the job to update the student's program info" do
              expect(CRM::UpsertProgramInfoJob).to receive(:perform_later)

              submission.update(
                published_at: Time.now
              )
            end
          end
        end

        context "when a non-CRM field is being updated" do
          it "does not call the job to update the student's program info" do
            expect(CRM::UpsertProgramInfoJob).not_to receive(:perform_later)

            submission.update(
              app_description: "My updated app details"
            )
          end
        end
      end

      context "when there aren't any students on the team" do
        before do
          submission.team.memberships = []
          submission.team.save!
          submission.team.reload
        end

        context "when a CRM field is being updated" do
          it "does not call the job to update the student's program info" do
            expect(CRM::UpsertProgramInfoJob).not_to receive(:perform_later)

            submission.update(
              pitch_video_link: "http://example.com/xzy-pitch-video"
            )
          end
        end
      end
    end
  end

  describe "ACTIVE_DEVELOPMENT_PLATFORMS_ENUM" do
    it "returns a list of active development platforms (in Rails enum format)" do
      expect(TeamSubmission::ACTIVE_DEVELOPMENT_PLATFORMS_ENUM).to eq({
        "App Inventor" => 0,
        "Thunkable" => 6,
        "Other" => 5,
        "Scratch" => 8,
        "Code.org App Lab" => 9
      })
    end
  end

  describe "INACTIVE_DEVELOPMENT_PLATFORMS_ENUM" do
    it "returns a list of inactive development platforms (in Rails enum format)" do
      expect(TeamSubmission::INACTIVE_DEVELOPMENT_PLATFORMS_ENUM).to eq({
        "C++" => 3,
        "PhoneGap/Apache Cordova" => 4,
        "Thunkable Classic" => 7,
        "Java or Android Studio" => 2,
        "Swift or XCode" => 1
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
        "Thunkable Classic" => 7,
        "Scratch" => 8,
        "Code.org App Lab" => 9
      })
    end
  end

  describe "DEVELOPMENT_PLATFORMS" do
    it "returns a list of (active) development platforms" do
      expect(TeamSubmission::DEVELOPMENT_PLATFORMS).to eq([
        "App Inventor",
        "Thunkable",
        "Other",
        "Scratch",
        "Code.org App Lab"
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

      submission.development_platform = "Scratch"
      expect(submission.developed_on?("Scratch")).to be true

      submission.development_platform = "Code.org App Lab"
      expect(submission.developed_on?("Code.org App Lab")).to be true
    end
  end

  describe "#app_details" do
    let(:submission) { FactoryBot.create(:submission) }

    context "when all additional questions are false" do
      it "returns false" do
        expect(submission.app_details).to eq(false)
      end
    end

    context "when only ai is true" do
      before do
        submission.update(ai: true, ai_description: "some description")
      end

      it "returns true" do
        expect(submission.app_details).to eq(true)
      end
    end

    context "when only climate change is true" do
      before do
        submission.update(climate_change: true, climate_change_description: "some description")
      end

      it "returns true" do
        expect(submission.app_details).to eq(true)
      end
    end

    context "when only game is true" do
      before do
        submission.update(game: true, game_description: "some ai description")
      end

      it "returns true" do
        expect(submission.app_details).to eq(true)
      end
    end

    context "when only uses open ai is true" do
      before do
        submission.update(uses_open_ai: true, uses_open_ai_description: "some ai description")
      end

      it "returns true" do
        expect(submission.app_details).to eq(true)
      end
    end

    context "when only solves education is true" do
      before do
        submission.update(solves_education: true, solves_education_description: "some ai description")
      end

      it "returns true" do
        expect(submission.app_details).to eq(true)
      end
    end

    context "when only uses gadgets is true" do
      before do
        submission.update(uses_gadgets: true)
      end

      it "returns true" do
        expect(submission.app_details).to eq(true)
      end
    end

    context "when all additional questions are true" do
      before do
        submission.update(
          ai: true,
          ai_description: "Some description",
          climate_change: true,
          climate_change_description: "Some description",
          game: true,
          game_description: "Some description",
          uses_open_ai: true,
          uses_open_ai_description: "Some description",
          solves_education: true,
          solves_education_description: "Some description",
          uses_gadgets: true
        )
      end

      it "returns true" do
        expect(submission.app_details).to eq(true)
      end
    end
  end

  describe "#additional_questions?" do
    let(:submission) { TeamSubmission.new(seasons: [season]) }

    context "when the season is 2020" do
      let(:season) { "2020" }

      it "returns false" do
        expect(submission.additional_questions?).to eq(false)
      end
    end

    context "when the season is 2021" do
      let(:season) { "2021" }

      it "returns true" do
        expect(submission.additional_questions?).to eq(true)
      end
    end

    context "when the season is 2022" do
      let(:season) { "2022" }

      it "returns true" do
        expect(submission.additional_questions?).to eq(true)
      end
    end

    context "when the season is 2025" do
      let(:season) { "2025" }

      it "returns true" do
        expect(submission.additional_questions?).to eq(true)
      end
    end
  end

  describe "#app_inventor_fields_complete?" do
    it "returns true when app inventor name is complete" do
      submission = FactoryBot.create(:submission)

      submission.development_platform = "App Inventor"
      submission.app_inventor_app_name = "Test App"
      expect(submission.app_inventor_fields_complete?).to be true
    end

    it "returns false when app inventor app name is missing" do
      submission = FactoryBot.create(:submission)

      submission.development_platform = "App Inventor"
      expect(submission.app_inventor_fields_complete?).to be false
    end
  end

  describe "#thunkable_fields_complete?" do
    it "returns true when all thunkable fields are complete" do
      submission = FactoryBot.create(:submission)

      submission.development_platform = "Thunkable"
      submission.thunkable_project_url = "https://x.thunkable.com/projectPage/47d800b3aa47590210ad662249e63dd4"
      expect(submission.thunkable_fields_complete?).to be true
    end

    it "returns false when thunkable project url is missing" do
      submission = FactoryBot.create(:submission)

      submission.development_platform = "Thunkable"
      expect(submission.thunkable_fields_complete?).to be false
    end
  end

  describe "#scratch_fields_complete?" do
    it "returns true when only scratch development platform is selected" do
      submission = FactoryBot.create(:submission)

      submission.development_platform = "Scratch"
      expect(submission.scratch_fields_complete?).to be true
    end

    it "returns true when all scratch fields are complete" do
      submission = FactoryBot.create(:submission)

      submission.development_platform = "Scratch"
      submission.scratch_project_url = "https://scratch.mit.edu/projects/12345"
      expect(submission.scratch_fields_complete?).to be true
    end

    it "returns false when scratch project url is present but the url is invalid" do
      submission = FactoryBot.create(:submission)

      submission.development_platform = "Scratch"
      submission.scratch_project_url = "https://scratch.mit.edu/12345"
      submission.valid?
      expect(submission.scratch_fields_complete?).to be false
    end
  end

  describe "#code_org_app_lab_fields_complete?" do
    it "returns true when all code.org app lab fields are complete" do
      submission = FactoryBot.create(:submission)

      submission.development_platform = "Code.org App Lab"
      submission.code_org_app_lab_project_url = "https://studio.code.org/projects/applab/12345"
      expect(submission.code_org_app_lab_fields_complete?).to be true
    end

    it "returns false when code.org app lab project url is missing" do
      submission = FactoryBot.create(:submission)

      submission.development_platform = "Code.org App Lab"
      expect(submission.code_org_app_lab_fields_complete?).to be false
    end
  end

  describe "#other_fields_complete?" do
    it "returns true when all thunkable fields are complete" do
      submission = FactoryBot.create(:submission)

      submission.development_platform = "Other"
      expect(submission.other_fields_complete?).to be true
    end
  end

  describe "#thunkable_source_code_fields_complete?" do
    it "returns true when thunkable project url is complete and all source code external fields are complete" do
      submission = FactoryBot.create(:submission)

      submission.development_platform = "Thunkable"
      submission.thunkable_project_url = "https://x.thunkable.com/projectPage/47d800b3aa47590210ad662249e63dd4"
      submission.source_code_external_url = "https://x.thunkable.com/projectPage/47d800b3aa47590210ad662249e63dd4"

      expect(submission.thunkable_source_code_fields_complete?).to be true
    end

    it "returns false when thunkable project url is complete and all source code external fields are incomplete " do
      submission = FactoryBot.create(:submission)

      submission.development_platform = "Thunkable"
      submission.thunkable_project_url = "https://x.thunkable.com/projectPage/47d800b3aa47590210ad662249e63dd4"
      submission.source_code_external_url = nil

      expect(submission.thunkable_source_code_fields_complete?).to be false
    end
  end

  describe "#scratch_source_code_fields_complete?" do
    it "returns true when scratch project url is complete and all source code external fields are complete" do
      submission = FactoryBot.create(:submission)

      submission.development_platform = "Scratch"
      submission.scratch_project_url = "https://scratch.mit.edu/projects/12345"
      submission.source_code_external_url = "https://scratch.mit.edu/projects/12345"

      expect(submission.scratch_source_code_fields_complete?).to be true
    end

    it "returns false when scratch project url is complete and all source code external fields are incomplete" do
      submission = FactoryBot.create(:submission)

      submission.development_platform = "Scratch"
      submission.scratch_project_url = "https://scratch.mit.edu/projects/12345"
      submission.source_code_external_url = nil

      expect(submission.scratch_source_code_fields_complete?).to be false
    end
  end

  describe "#code_org_app_lab_source_code_fields_complete?" do
    it "returns true when code.org app lab project url is complete and all source code external fields are complete" do
      submission = FactoryBot.create(:submission)

      submission.development_platform = "Code.org App Lab"
      submission.code_org_app_lab_project_url = "https://studio.code.org/projects/applab/12345"
      submission.source_code_external_url = "https://studio.code.org/projects/applab/12345"

      expect(submission.code_org_app_lab_source_code_fields_complete?).to be true
    end

    it "returns false when code.org app lab project url is complete and all source code external fields are incomplete " do
      submission = FactoryBot.create(:submission)

      submission.development_platform = "Code.org App Lab"
      submission.code_org_app_lab_project_url = "https://studio.code.org/projects/applab/12345"
      submission.source_code_external_url = nil

      expect(submission.code_org_app_lab_source_code_fields_complete?).to be false
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
      it "returns 0% when no required items have been completed" do
        junior_submission = FactoryBot.create(:submission, :junior)

        expect(junior_submission.percent_complete).to eq(0)
      end

      it "returns 8% when one required item has been completed" do
        junior_submission = FactoryBot.create(:submission, :junior)

        junior_submission.update(app_name: "An amazing app")

        expect(junior_submission.percent_complete).to eq(8)
      end

      it "returns 92% when all required items have been completed, but it hasn't been published yet" do
        junior_submission = FactoryBot.create(:submission, :junior, :complete)

        junior_submission.update(published_at: nil)

        expect(junior_submission.percent_complete).to eq(92)
      end

      it "returns 100% when all required items have been completed, and it has been published" do
        junior_submission = FactoryBot.create(:submission, :junior, :complete)

        junior_submission.publish!

        expect(junior_submission.percent_complete).to eq(100)
      end
    end

    context "when a senior team is submitting" do
      it "returns 0% when no required items have been completed" do
        senior_submission = FactoryBot.create(:submission, :senior)

        expect(senior_submission.percent_complete).to eq(0)
      end

      it "returns 8% when one required item has been completed" do
        senior_submission = FactoryBot.create(:submission, :senior)

        senior_submission.update(app_name: "Fantastico Magnifico")

        expect(senior_submission.percent_complete).to eq(8)
      end

      it "returns 92% when all required items have been completed, but it hasn't been published yet" do
        senior_submission = FactoryBot.create(:submission, :senior, :complete)

        senior_submission.update(published_at: nil)

        expect(senior_submission.percent_complete).to eq(92)
      end

      it "returns 100% when all required items have been completed, and it has been published" do
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

    Submissions::RequiredFields.new(sub).each do |field|
      if field.method_name == :screenshots
        sub.screenshots.destroy_all
      elsif field.method_name == :development_platform_text
        sub.update(development_platform: nil)
      elsif field.method_name == :source_code_url
        sub.remove_source_code!
      elsif field.method_name == :ai_usage
        sub.update(ai_usage: nil)
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

    describe "for official RPE" do
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
            completed_at: Time.current,
            event_type: "live"
          })
        end

        [4, 2].each do |score|
          virtual_judge = FactoryBot.create(:judge_profile)
          virtual_judge.submission_scores.create!({
            team_submission: sub,
            ideation_1: score,
            completed_at: Time.current,
            event_type: "virtual"
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
            completed_at: Time.current,
            event_type: "live"
          })
        end

        [11].each do |score|
          virtual_judge = FactoryBot.create(:judge_profile)
          virtual_judge.submission_scores.create!({
            team_submission: sub,
            ideation_1: score,
            completed_at: Time.current,
            event_type: "virtual"
          })
        end

        expect(sub.reload.quarterfinals_score_range).to eq(9)
      end
    end

    describe "for unofficial RPE" do
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
          completed_at: Time.current,
          event_type: "live"
        })

        virtual_score = virtual_judge.submission_scores.create!({
          team_submission: sub,
          ideation_1: 2,
          completed_at: Time.current,
          event_type: "virtual"
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
            completed_at: Time.current,
            event_type: "live"
          })
        end

        [4, 2].each do |score|
          virtual_judge = FactoryBot.create(:judge_profile)
          virtual_judge.submission_scores.create!({
            team_submission: sub,
            ideation_1: score,
            completed_at: Time.current,
            event_type: "virtual"
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

  describe "#unpublish!" do
    let(:team_submission) { FactoryBot.create(:submission, :complete) }

    it "unpublishes a submission by resetting the `published_at` field" do
      team_submission.unpublish!

      expect(team_submission.published_at).to be_blank
    end
  end

  describe "#missing_pieces" do
    let(:team_submission) { TeamSubmission.new }

    before do
      allow(Submissions::RequiredFields).to receive(:new).with(team_submission).and_return(required_fields)
    end

    let(:required_fields) { [double("required fields", method_name: :app_name, blank?: true, complete?: false)] }

    context "when the submission is incomplete" do
      before do
        allow(team_submission).to receive(:incomplete?).and_return(true)
      end

      it "returns an array of missing pieces, including 'submitting' since the submission is incomplete" do
        expect(team_submission.missing_pieces).to eq(["app_name", "submitting"])
      end

      context "when images (formally known as screenshots) are missing" do
        let(:required_fields) { [double("required fields", method_name: :screenshots, blank?: true, complete?: false)] }

        it "returns 'images' instead of 'screenshots'" do
          expect(team_submission.missing_pieces).to include("images")
          expect(team_submission.missing_pieces).not_to include("screenshots")
        end
      end
    end

    context "when the submission is complete" do
      before do
        allow(team_submission).to receive(:incomplete?).and_return(false)
      end

      let(:required_fields) { [] }

      it "returns an empty array" do
        expect(team_submission.missing_pieces).to eq([])
      end
    end

    describe ".by_chapterable(scope)" do
      let(:chapter) { FactoryBot.create(:chapter) }
      let(:club) { FactoryBot.create(:club) }

      it "finds submissions with students assigned to a chapter in the current season" do
        team = FactoryBot.create(:team)
        student = team.students.first
        submission = FactoryBot.create(:submission, team: team)

        student.chapterable_assignments.destroy_all
        student.chapterable_assignments.create(
          chapterable: chapter,
          account: student.account,
          season: Season.current.year,
          primary: true
        )

        results = TeamSubmission.by_chapterable("Chapter", chapter.id, Season.current.year)
        expect(results).to include(submission)
      end

      it "finds submissions with students assigned to a club in the current season" do
        team = FactoryBot.create(:team)
        student = team.students.first
        submission = FactoryBot.create(:submission, team: team)

        student.chapterable_assignments.destroy_all
        student.chapterable_assignments.create(
          chapterable: club,
          account: student.account,
          season: Season.current.year,
          primary: true
        )

        results = TeamSubmission.by_chapterable("Club", club.id, Season.current.year)
        expect(results).to include(submission)
      end

      it "excludes submissions from past seasons when filtering by current season" do
        past_team = FactoryBot.create(:team, seasons: [Season.current.year - 1])
        student = past_team.students.first
        past_submission = FactoryBot.create(:submission, team: past_team)


        student.chapterable_assignments.destroy_all
        student.chapterable_assignments.create(
          chapterable: chapter,
          account: student.account,
          season: Season.current.year - 1,
          primary: true
        )

        results = TeamSubmission.by_chapterable("Chapter", chapter.id, Season.current.year)
        expect(results).not_to include(past_submission)
      end

      it "includes the same submission in multiple chapter filter results when students belong to different chapters" do
        other_chapter = FactoryBot.create(:chapter)
        team = FactoryBot.create(:team, members_count: 2)
        student1 = team.students.first
        student2 = team.students.second
        submission = FactoryBot.create(:submission, team: team)

        student1.chapterable_assignments.destroy_all
        student1.chapterable_assignments.create(
          chapterable: chapter,
          account: student1.account,
          season: Season.current.year,
          primary: true
        )

        student2.chapterable_assignments.destroy_all
        student2.chapterable_assignments.create(
          chapterable: other_chapter,
          account: student2.account,
          season: Season.current.year,
          primary: true
        )

        results = TeamSubmission.by_chapterable("Chapter", chapter.id, Season.current.year)
        expect(results).to include(submission)

        other_chapter_results = TeamSubmission.by_chapterable("Chapter", other_chapter.id, Season.current.year)
        expect(other_chapter_results).to include(submission)
      end
    end
  end
end
