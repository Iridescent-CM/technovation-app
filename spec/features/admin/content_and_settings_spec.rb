require "rails_helper"

RSpec.feature "Season controls exposed through Content & Settings tab", js: true do
  let(:admin) { FactoryBot.create(:admin) }

  before do
    sign_in(admin)
    expect(page).to have_content("Welcome back!")

    visit edit_admin_season_schedule_settings_path
  end

  context "Checkbox controls" do
    scenario "Unchecking all boxes" do
      uncheck_all_toggles

      click_button "Review"
      click_button "Save these settings"

      expect(SeasonToggles.student_signup?).to eq(false)
      expect(SeasonToggles.mentor_signup?).to eq(false)

      expect(SeasonToggles.team_building_enabled?).to eq(false)
      expect(SeasonToggles.team_submissions_editable?).to eq(false)

      expect(SeasonToggles.select_regional_pitch_event?).to eq(false)

      expect(SeasonToggles.display_scores?).to eq(false)
    end

    scenario "Checking all boxes" do
      check_all_toggles

      click_button "Review"
      click_button "Save these settings"

      expect(SeasonToggles.student_signup?).to eq(true)
      expect(SeasonToggles.mentor_signup?).to eq(true)

      expect(SeasonToggles.team_building_enabled?).to eq(true)
      expect(SeasonToggles.team_submissions_editable?).to eq(true)

      expect(SeasonToggles.select_regional_pitch_event?).to eq(true)

      expect(SeasonToggles.display_scores?).to eq(true)
    end
  end

  context "Notices" do
    scenario "Unsetting notices" do
      click_button "Notices"
      fill_in "Students", with: ""
      fill_in "Mentors", with: ""
      fill_in "Judges", with: ""
      fill_in "Chapter ambassadors", with: ""

      click_button "Review"
      click_button "Save these settings"

      expect(SeasonToggles.dashboard_text(:student)).to eq("")
      expect(SeasonToggles.dashboard_text(:mentor)).to eq("")
      expect(SeasonToggles.dashboard_text(:judge)).to eq("")
      expect(SeasonToggles.dashboard_text(:chapter_ambassador)).to eq("")
    end

    scenario "Setting notices" do
      click_button "Notices"
      fill_in "Students", with: "Student notice"
      fill_in "Mentors", with: "Mentor notice"
      fill_in "Judges", with: "Judge notice"
      fill_in "Chapter ambassadors", with: "Chapter ambassador notice"

      click_button "Review"
      click_button "Save these settings"

      expect(SeasonToggles.dashboard_text(:student)).to eq("Student notice")
      expect(SeasonToggles.dashboard_text(:mentor)).to eq("Mentor notice")
      expect(SeasonToggles.dashboard_text(:judge)).to eq("Judge notice")
      expect(SeasonToggles.dashboard_text(:chapter_ambassador)).to eq("Chapter ambassador notice")
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

      expect(SeasonToggles.survey_link(:student, :text)).to eq("")
      expect(SeasonToggles.survey_link(:student, :url)).to eq("")
      expect(SeasonToggles.survey_link(:student, :long_desc)).to eq("")

      expect(SeasonToggles.survey_link(:mentor, :text)).to eq("")
      expect(SeasonToggles.survey_link(:mentor, :url)).to eq("")
      expect(SeasonToggles.survey_link(:mentor, :long_desc)).to eq("")
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

  context "Judging round constraints" do
    ["Quarterfinals", "Between rounds", "Semifinals"].each do |round|
      scenario "Setting #{round.downcase} turns off other season toggles" do
        check_all_toggles

        click_button "Judging"
        choose round

        click_button "Review"
        click_button "Save these settings"

        expect(SeasonToggles.student_signup?).to eq(false)
        expect(SeasonToggles.mentor_signup?).to eq(false)
        expect(SeasonToggles.team_building_enabled?).to eq(false)
        expect(SeasonToggles.team_submissions_editable?).to eq(false)
        expect(SeasonToggles.select_regional_pitch_event?).to eq(false)
        expect(SeasonToggles.display_scores?).to eq(false)
      end

      scenario "Setting #{round.downcase} shows constraint alerts" do
        check_all_toggles

        click_button "Judging"
        choose round

        expect(page).to have_content("Enabling judging has affected other season features.")

        click_button "Registration"
        expect(page).to have_content("When judging is enabled", count: 2)

        click_button "Teams & Submissions"
        expect(page).to have_content("When judging is enabled", count: 2)

        click_button "Events"
        expect(page).to have_content("When judging is enabled", count: 1)

        click_button "Scores & Certificates"
        expect(page).to have_content("When judging is enabled", count: 1)
      end

      scenario "Setting #{round.downcase} disables and unchecks other toggle checkboxes" do
        check_all_toggles

        click_button "Judging"
        choose round

        click_button "Registration"
        expect(page).to have_unchecked_field("Students", disabled: true)
        expect(page).to have_unchecked_field("Mentors", disabled: true)

        click_button "Teams & Submissions"
        expect(page).to have_unchecked_field("Forming teams allowed", disabled: true)
        expect(page).to have_unchecked_field("Team submissions are editable", disabled: true)

        click_button "Events"
        expect(page).to have_unchecked_field("Selecting regional pitch events allowed", disabled: true)

        click_button "Scores & Certificates"
        expect(page).to have_unchecked_field("Scores & Certificates Accessible", disabled: true)
      end
    end

    ["Off", "Finished"].each do |round|
      scenario "Setting #{round.downcase} does not turn off other season toggles" do
        check_all_toggles

        click_button "Judging"
        choose round

        click_button "Review"
        click_button "Save these settings"

        expect(SeasonToggles.student_signup?).to eq(true)
        expect(SeasonToggles.mentor_signup?).to eq(true)
        expect(SeasonToggles.team_building_enabled?).to eq(true)
        expect(SeasonToggles.team_submissions_editable?).to eq(true)
        expect(SeasonToggles.select_regional_pitch_event?).to eq(true)
        expect(SeasonToggles.display_scores?).to eq(true)
      end

      scenario "Setting #{round.downcase} hides constraint alerts" do
        click_button "Judging"
        choose round

        expect(page).not_to have_content("Enabling judging has affected other season features.")

        click_button "Registration"
        expect(page).not_to have_content("When judging is enabled")

        click_button "Teams & Submissions"
        expect(page).not_to have_content("When judging is enabled")

        click_button "Events"
        expect(page).not_to have_content("When judging is enabled")

        click_button "Scores & Certificates"
        expect(page).not_to have_content("When judging is enabled")
      end

      scenario "Setting #{round.downcase} enables other toggle checkboxes" do
        click_button "Judging"
        choose round

        click_button "Registration"
        expect(page).to have_field("Students", disabled: false)
        expect(page).to have_field("Mentors", disabled: false)

        click_button "Teams & Submissions"
        expect(page).to have_field("Forming teams allowed", disabled: false)
        expect(page).to have_field("Team submissions are editable", disabled: false)

        click_button "Events"
        expect(page).to have_field("Selecting regional pitch events allowed", disabled: false)

        click_button "Scores & Certificates"
        expect(page).to have_field("Scores & Certificates Accessible", disabled: false)
      end
    end
  end

  def uncheck_all_toggles
    click_button "Registration"
    uncheck "Students"
    uncheck "Mentors"

    click_button "Teams & Submissions"
    uncheck "Forming teams allowed"
    uncheck "Team submissions are editable"

    click_button "Events"
    uncheck "Selecting regional pitch events allowed"

    click_button "Scores & Certificates"
    uncheck "Scores & Certificates Accessible"
  end

  def check_all_toggles
    click_button "Registration"
    check "Students"
    check "Mentors"

    click_button "Teams & Submissions"
    check "Forming teams allowed"
    check "Team submissions are editable"

    click_button "Events"
    check "Selecting regional pitch events allowed"

    click_button "Scores & Certificates"
    check "Scores & Certificates Accessible"
  end
end
