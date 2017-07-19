require "rails_helper"

RSpec.feature "Team submissions editable toggles team roster controls" do

  def toggle_on
    SeasonToggles.team_building_enabled = "on"
  end

  def toggle_off
    SeasonToggles.team_building_enabled = "off"
  end

  context "Student nav bar, no team" do
    let(:user) { FactoryGirl.create(:student) }
    let(:path) { student_dashboard_path }

    before { sign_in(user) }

    scenario "Toggle on" do
      toggle_on
      visit path
      within("header.navigation nav") do
        expect(page).to have_link("Create a team")
        expect(page).to have_link("Join a team")
      end
    end

    scenario "Toggle off" do
      toggle_off
      visit path
      within("header.navigation nav") do
        expect(page).not_to have_link("Create a team")
        expect(page).not_to have_link("Join a team")
      end
    end
  end

  context "Student nav bar, with team" do
    let(:user) { FactoryGirl.create(:student, :on_team) }
    let(:path) { student_dashboard_path }

    before { sign_in(user) }

    scenario "Toggle on" do
      toggle_on
      visit path
      within("header.navigation nav") do
        expect(page).to have_link("Find a mentor")
      end
    end

    scenario "Toggle off" do
      toggle_off
      visit path
      within("header.navigation nav") do
        expect(page).not_to have_link("Find a mentor")
      end
    end
  end

  context "Student dashboard" do
    let(:user) { FactoryGirl.create(:student) }
    let(:path) { student_dashboard_path }

    before { sign_in(user) }

    scenario "Toggle on" do
      toggle_on
      visit path

      within("#your-submission") do
        expect(page).to have_link("Join a team")
        expect(page).to have_link("Create a team")
      end

      within("#live-events") do
        expect(page).to have_link("Join a team")
        expect(page).to have_link("Create a team")
      end
    end

    scenario "Toggle off" do
      toggle_off
      visit path

      expect(page).not_to have_link("Join a team")
      expect(page).not_to have_link("Create a team")
    end
  end

  context "Viewing team as student" do
    let(:user) { FactoryGirl.create(:student) }
    let(:team) { FactoryGirl.create(:team) }
    let(:path) { new_student_join_request_path(team_id: team.id) }
    let(:action) { student_join_requests_path(team_id: team.id) }

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

  context "Viewing current team as student" do
    let(:user) { FactoryGirl.create(:student, :on_team) }
    let(:team) { user.team }
    let(:path) { student_team_path(id: team.id) }
    let(:action) { student_team_member_invites_path }

    before { sign_in(user) }

    scenario "Toggle on" do
      toggle_on
      visit path
      expect(page).to have_css("form[action='#{action}']")
      expect(page).to have_link("Find a mentor")
    end

    scenario "Toggle off" do
      toggle_off
      visit path
      expect(page).not_to have_css("form[action='#{action}']")
      expect(page).not_to have_link("Find a mentor")
    end
  end

  context "Viewing current team as student, with pending request" do
    let(:user) { FactoryGirl.create(:student, :on_team) }
    let(:team) { user.team }
    let!(:request) { FactoryGirl.create(:join_request, joinable: team) }
    let(:path) { student_team_path(id: team.id) }

    before { sign_in(user) }

    scenario "Toggle on" do
      toggle_on
      visit path
      expect(page).to have_css("div.pending-requests")
    end

    scenario "Toggle off" do
      toggle_off
      visit path
      expect(page).not_to have_css("div.pending-requests")
    end
  end

  context "Viewing mentor profile as student" do
    let(:user) { FactoryGirl.create(:student, :on_team) }
    let(:mentor) { FactoryGirl.create(:mentor) }
    let(:path) { student_mentor_path(id: mentor.id) }
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
    let(:user) { FactoryGirl.create(:mentor) }
    let(:path) { mentor_dashboard_path }

    before { sign_in(user) }

    scenario "Toggle on" do
      toggle_on
      visit path
      within("#pitch-events") do
        expect(page).to have_link("Join a team")
        expect(page).to have_link("Create a team")
      end
    end

    scenario "Toggle off" do
      toggle_off
      visit path
      expect(page).not_to have_link("Join a team")
      expect(page).not_to have_link("Create a team")
    end
  end

  context "Mentor my teams page" do
    let(:user) { FactoryGirl.create(:mentor) }
    let(:path) { mentor_teams_path }

    before { sign_in(user) }

    scenario "Toggle on" do
      toggle_on
      visit path
      expect(page).to have_link("Create a new team")
      expect(page).to have_link("Browse available teams")
    end

    scenario "Toggle off" do
      toggle_off
      visit path
      expect(page).not_to have_link("Create a new team")
      expect(page).not_to have_link("Browse available teams")
    end
  end

  context "Viewing team as mentor" do
    let(:user) { FactoryGirl.create(:mentor) }
    let(:team) { FactoryGirl.create(:team) }
    let(:path) { new_mentor_join_request_path(team_id: team.id) }
    let(:action) { mentor_join_requests_path(team_id: team.id) }

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

  context "Viewing current team as mentor" do
    let(:user) { FactoryGirl.create(:mentor) }
    let(:team) { FactoryGirl.create(:team) }
    let(:path) { mentor_team_path(id: team.id) }
    let(:action) { mentor_team_member_invites_path }

    before {
      TeamRosterManaging.add(team, user)
      sign_in(user)
    }

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
