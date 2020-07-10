require "rails_helper"

RSpec.feature "Season controls exposed through Content & Settings tab", js: true do
  let(:admin) { FactoryBot.create(:admin) }

  before do
    sign_in(admin)
    visit edit_admin_season_schedule_settings_path
  end

  context "Checkbox controls" do
    scenario "Unchecking all boxes" do
      click_button "Registration"
      uncheck "Students"
      uncheck "Mentors"
      uncheck "Judges"
      uncheck "Regional Ambassadors"

      click_button "Teams & Submissions"
      uncheck "Forming teams allowed"
      uncheck "Team submissions are editable"

      click_button "Events"
      uncheck "Selecting regional pitch events allowed"

      click_button "Scores & Certificates"
      uncheck "Scores & Certificates Accessible"

      click_button "Review"
      click_button "Save these settings"

      expect(SeasonToggles.student_signup?).to be false
      expect(SeasonToggles.mentor_signup?).to be false
      expect(SeasonToggles.judge_signup?).to be false
      expect(SeasonToggles.regional_ambassador_signup?).to be false

      expect(SeasonToggles.team_building_enabled?).to be false
      expect(SeasonToggles.team_submissions_editable?).to be false

      expect(SeasonToggles.select_regional_pitch_event?).to be false

      expect(SeasonToggles.display_scores?).to be false
    end

    scenario "Checking all boxes" do
      click_button "Registration"
      check "Students"
      check "Mentors"
      check "Judges"
      check "Regional Ambassadors"

      click_button "Teams & Submissions"
      check "Forming teams allowed"
      check "Team submissions are editable"

      click_button "Events"
      check "Selecting regional pitch events allowed"

      click_button "Scores & Certificates"
      check "Scores & Certificates Accessible"

      click_button "Review"
      click_button "Save these settings"

      expect(SeasonToggles.student_signup?).to be true
      expect(SeasonToggles.mentor_signup?).to be true
      expect(SeasonToggles.judge_signup?).to be true
      expect(SeasonToggles.regional_ambassador_signup?).to be true

      expect(SeasonToggles.team_building_enabled?).to be true
      expect(SeasonToggles.team_submissions_editable?).to be true

      expect(SeasonToggles.select_regional_pitch_event?).to be true

      expect(SeasonToggles.display_scores?).to be true
    end
  end

  context "Notices" do
    scenario "Unsetting notices" do
      click_button "Notices"
      fill_in "Students", with: ""
      fill_in "Mentors", with: ""
      fill_in "Judges", with: ""
      fill_in "Regional ambassadors", with: ""

      click_button "Review"
      click_button "Save these settings"

      expect(SeasonToggles.dashboard_text(:student)).to be_empty
      expect(SeasonToggles.dashboard_text(:mentor)).to be_empty
      expect(SeasonToggles.dashboard_text(:judge)).to be_empty
      expect(SeasonToggles.dashboard_text(:regional_ambassador)).to be_empty
    end

    scenario "Setting notices" do
      click_button "Notices"
      fill_in "Students", with: "Student notice"
      fill_in "Mentors", with: "Mentor notice"
      fill_in "Judges", with: "Judge notice"
      fill_in "Regional ambassadors", with: "Regional ambassador notice"

      click_button "Review"
      click_button "Save these settings"

      expect(SeasonToggles.dashboard_text(:student)).to eq("Student notice")
      expect(SeasonToggles.dashboard_text(:mentor)).to eq("Mentor notice")
      expect(SeasonToggles.dashboard_text(:judge)).to eq("Judge notice")
      expect(SeasonToggles.dashboard_text(:regional_ambassador)).to eq("Regional ambassador notice")
    end
  end

  context "Surveys" do
    scenario "Unsetting survey fields" do
      click_button "Surveys"
      fill_in "season_toggles_student_survey_link_text", with: ""
      fill_in "season_toggles_student_survey_link_url", with: ""
      fill_in "season_toggles_student_survey_link_long_desc", with: ""

      fill_in "season_toggles_mentor_survey_link_text", with: ""
      fill_in "season_toggles_mentor_survey_link_url", with: ""
      fill_in "season_toggles_mentor_survey_link_long_desc", with: ""

      click_button "Review"
      click_button "Save these settings"

      expect(SeasonToggles.survey_link(:student, :text)).to be_empty
      expect(SeasonToggles.survey_link(:student, :url)).to be_empty
      expect(SeasonToggles.survey_link(:student, :long_desc)).to be_empty

      expect(SeasonToggles.survey_link(:mentor, :text)).to be_empty
      expect(SeasonToggles.survey_link(:mentor, :url)).to be_empty
      expect(SeasonToggles.survey_link(:mentor, :long_desc)).to be_empty
    end

    scenario "Setting survey fields" do
      click_button "Surveys"
      fill_in "season_toggles_student_survey_link_text", with: "student link text"
      fill_in "season_toggles_student_survey_link_url", with: "http://example.com/student"
      fill_in "season_toggles_student_survey_link_long_desc", with: "student long desc"

      fill_in "season_toggles_mentor_survey_link_text", with: "mentor link text"
      fill_in "season_toggles_mentor_survey_link_url", with: "http://example.com/mentor"
      fill_in "season_toggles_mentor_survey_link_long_desc", with: "mentor long desc"

      click_button "Review"
      click_button "Save these settings"

      expect(SeasonToggles.survey_link(:student, :text)).to eq("student link text")
      expect(SeasonToggles.survey_link(:student, :url)).to eq("http://example.com/student")
      expect(SeasonToggles.survey_link(:student, :long_desc)).to eq("student long desc")

      expect(SeasonToggles.survey_link(:mentor, :text)).to eq("mentor link text")
      expect(SeasonToggles.survey_link(:mentor, :url)).to eq("http://example.com/mentor")
      expect(SeasonToggles.survey_link(:mentor, :long_desc)).to eq("mentor long desc")
    end
  end

  context "Judging round controls" do
    scenario "Turning off" do
      click_button "Judging"
      choose "Off"

      click_button "Review"
      click_button "Save these settings"

      expect(SeasonToggles.judging_round).to eq("off")
    end

    scenario "Setting quarterfinals" do
      click_button "Judging"
      choose "Quarterfinals"

      click_button "Review"
      click_button "Save these settings"

      expect(SeasonToggles.judging_round).to eq("qf")
    end

    scenario "Setting between rounds" do
      click_button "Judging"
      choose "Between rounds"

      click_button "Review"
      click_button "Save these settings"

      expect(SeasonToggles.judging_round).to eq("between")
    end

    scenario "Setting semifinals" do
      click_button "Judging"
      choose "Semifinals"

      click_button "Review"
      click_button "Save these settings"

      expect(SeasonToggles.judging_round).to eq("sf")
    end

    scenario "Setting to finished" do
      click_button "Judging"
      choose "Finished"

      click_button "Review"
      click_button "Save these settings"

      expect(SeasonToggles.judging_round).to eq("finished")
    end
  end
end
