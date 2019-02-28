require "rails_helper"

RSpec.feature "Team submissions editable toggles team roster controls" do

  def toggle_on
    SeasonToggles.team_building_enabled = "on"
  end

  def toggle_off
    SeasonToggles.team_building_enabled = "off"
  end

  context "Student nav bar, no team" do
    let(:user) { FactoryBot.create(:student) }
    let(:path) { student_dashboard_path }

    before { sign_in(user) }

    scenario "Toggle on" do
      toggle_on
      visit path
      within("header.navigation nav") do
        expect(page).to have_link("Create your team")
        expect(page).to have_link("Find a team")
      end
    end

    scenario "Toggle off" do
      toggle_off
      visit path
      within("header.navigation nav") do
        expect(page).not_to have_link("Create your team")
        expect(page).not_to have_link("Find a team")
      end
    end
  end

  context "Student team page, with team" do
    let(:user) { FactoryBot.create(:student, :on_team) }
    let(:path) { student_team_path(user.team) }

    before { sign_in(user) }

    scenario "Toggle on" do
      toggle_on
      visit path
      expect(page).to have_link("Add a mentor")
    end

    scenario "Toggle off" do
      toggle_off
      visit path
      expect(page).not_to have_link("Add a mentor")
    end
  end

  context "Viewing team as student" do
    let(:user) { FactoryBot.create(:student) }
    let(:team) { FactoryBot.create(:team) }
    let(:path) { new_student_join_request_path(team_id: team.id) }
    let(:action) { student_join_requests_path(team_id: team.id) }

    before do
      Timecop.freeze(ImportantDates.quarterfinals_judging_begins - 1.day)
      sign_in(user)
    end

    after do
      Timecop.return
    end

    scenario "Toggle on" do
      toggle_on
      visit path
      expect(page).to have_css("form[action='#{action}']")
    end

    scenario "Toggle off" do
      toggle_off
      visit path
      expect(page).not_to have_css("form[action='#{action}']")
    end
  end

  context "Viewing current team as student" do
    let(:user) { FactoryBot.create(:student, :on_team) }
    let(:team) { user.team }
    let(:path) { student_team_path(team) }
    let(:action) { student_team_member_invites_path }

    before do
      Timecop.freeze(ImportantDates.quarterfinals_judging_begins - 1.day)
      sign_in(user)
    end

    after do
      Timecop.return
    end

    scenario "Toggle on" do
      toggle_on
      visit path
      expect(page).to have_css("form[action='#{action}']")
      expect(page).to have_link("Add a mentor")
    end

    scenario "Toggle off" do
      toggle_off
      visit path
      expect(page).not_to have_css("form[action='#{action}']")
      expect(page).not_to have_link("Add a mentor")
    end
  end

  context "Viewing mentor profile as student" do
    let(:user) { FactoryBot.create(:student, :on_team) }
    let(:mentor) { FactoryBot.create(:mentor, :onboarded) }
    let(:path) { student_mentor_path(mentor) }
    let(:action) { student_mentor_invites_path }

    before { sign_in(user) }

    scenario "Toggle on" do
      toggle_on
      visit path
      expect(page).to have_css("form[action='#{action}']")
    end

    scenario "Toggle off" do
      toggle_off
      visit path
      expect(page).not_to have_css("form[action='#{action}']")
    end
  end

  context "Mentor dashboard" do
    let(:user) { FactoryBot.create(:mentor, :onboarded) }
    let(:path) { mentor_dashboard_path }

    before { sign_in(user) }

    scenario "Toggle off" do
      toggle_on
      toggle_off
      visit path
      expect(page).not_to have_link("Find a team")
      expect(page).not_to have_link("Create your team")
    end
  end

  context "Mentor my teams page" do
    let(:user) { FactoryBot.create(:mentor, :onboarded) }
    let(:path) { mentor_dashboard_path }

    before { sign_in(user) }

    scenario "Toggle on" do
      toggle_on
      visit path
      expect(page).to have_link("Create your team")
      expect(page).to have_link("Find more teams")
    end

    scenario "Toggle off" do
      toggle_off
      visit path
      expect(page).not_to have_link("Create your team")
      expect(page).not_to have_link("Find more teams")
    end
  end

  context "Viewing team as mentor" do
    let(:user) { FactoryBot.create(:mentor, :onboarded) }
    let(:team) { FactoryBot.create(:team) }
    let(:path) { new_mentor_join_request_path(team_id: team.id) }
    let(:action) { mentor_join_requests_path(team_id: team.id) }

    before do
      Timecop.freeze(ImportantDates.quarterfinals_judging_begins - 1.day)
      sign_in(user)
    end

    after do
      Timecop.return
    end

    scenario "Toggle on" do
      toggle_on
      visit path
      expect(page).to have_css("form[action='#{action}']")
    end

    scenario "Toggle off" do
      toggle_off
      visit path
      expect(page).not_to have_css("form[action='#{action}']")
    end
  end

  context "Viewing current team as mentor" do
    let(:user) { FactoryBot.create(:mentor, :onboarded) }
    let(:team) { FactoryBot.create(:team) }
    let(:path) { mentor_team_path(team) }
    let(:action) { mentor_team_member_invites_path }

    before do
      Timecop.freeze(ImportantDates.quarterfinals_judging_begins - 1.day)
      TeamRosterManaging.add(team, user)
      sign_in(user)
    end

    after do
      Timecop.return
    end

    scenario "Toggle on" do
      toggle_on
      visit path
      expect(page).to have_css("form[action='#{action}']")
    end

    scenario "Toggle off" do
      toggle_off
      visit path
      expect(page).not_to have_css("form[action='#{action}']")
    end
  end
end
