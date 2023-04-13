require "rails_helper"

RSpec.feature "Team submissions editable toggles team roster controls" do

  def enable_team_building
    SeasonToggles.team_building_enabled = "on"
  end

  def disable_team_building
    SeasonToggles.team_building_enabled = "off"
  end

  context "Viewing find/create a team links as a student" do
    let(:student) { FactoryBot.create(:student) }

    before { sign_in(student) }

    scenario "Team building enabled" do
      enable_team_building
      visit student_dashboard_path

      within("div .sub-nav-wrapper nav") do
        expect(page).to have_link("Create your team")
        expect(page).to have_link("Find a team")
      end
    end

    scenario "Team building disabled" do
      disable_team_building
      visit student_dashboard_path

      within("div .sub-nav-wrapper nav") do
        expect(page).not_to have_link("Create your team")
        expect(page).not_to have_link("Find a team")
      end
    end
  end

  context "Students looking for mentors to join their team" do
    let(:student) { FactoryBot.create(:student, :on_team) }

    before { sign_in(student) }

    scenario "Team building enabled" do
      enable_team_building
      visit student_team_path(student.team)

      expect(page).to have_link("Find a mentor to join your team")
    end

    scenario "Team building disabled" do
      disable_team_building
      visit student_team_path(student.team)

      expect(page).not_to have_link("Find a mentor to join your team")
    end
  end

  context "Viewing join requests as a student" do
    let(:student) { FactoryBot.create(:student) }
    let(:team) { FactoryBot.create(:team) }
    let(:action) { student_join_requests_path(team_id: team.id) }

    before do
      Timecop.freeze(ImportantDates.quarterfinals_judging_begins - 1.day)
      sign_in(student)
    end

    after do
      Timecop.return
    end

    scenario "Team building enabled" do
      enable_team_building
      visit new_student_join_request_path(team_id: team.id)

      expect(page).to have_css("form[action='#{action}']")
    end

    scenario "Team building disabled" do
      disable_team_building
      visit new_student_join_request_path(team_id: team.id)

      expect(page).not_to have_css("form[action='#{action}']")
    end
  end

  context "Viewing invites as a student" do
    let(:student) { FactoryBot.create(:student, :on_team) }
    let(:team) { student.team }
    let(:action) { student_team_member_invites_path }

    before do
      Timecop.freeze(ImportantDates.quarterfinals_judging_begins - 1.day)
      sign_in(student)
    end

    after do
      Timecop.return
    end

    scenario "Team building enabled" do
      enable_team_building
      visit student_team_path(team)

      expect(page).to have_css("form[action='#{action}']")
      expect(page).to have_link("Find a mentor to join your team")
    end

    scenario "Team building disabled" do
      disable_team_building
      visit student_team_path(team)

      expect(page).not_to have_css("form[action='#{action}']")
      expect(page).not_to have_link("Find a mentor to join your team")
    end
  end

  context "Viwing mentor invites as a student" do
    let(:student) { FactoryBot.create(:student, :on_team) }
    let(:mentor) { FactoryBot.create(:mentor, :onboarded) }
    let(:action) { student_mentor_invites_path }

    before { sign_in(student) }

    scenario "Team building enabled" do
      enable_team_building
      visit student_mentor_path(mentor)

      expect(page).to have_css("form[action='#{action}']")
    end

    scenario "Team building disabled" do
      disable_team_building
      visit student_mentor_path(mentor)

      expect(page).not_to have_css("form[action='#{action}']")
    end
  end

  context "Viewing find/create a team links as a mentor" do
    let(:mentor) { FactoryBot.create(:mentor, :onboarded) }

    before { sign_in(mentor) }

    scenario "Team building enabled" do
      enable_team_building
      visit mentor_dashboard_path

      expect(page).to have_link("Find a team")
      expect(page).to have_link("Create your team")
    end

    scenario "Team building disabled" do
      disable_team_building
      visit mentor_dashboard_path

      expect(page).not_to have_link("Find a team")
      expect(page).not_to have_link("Create your team")
    end
  end

  context "Viewing join requests as a mentor" do
    let(:mentor) { FactoryBot.create(:mentor, :onboarded) }
    let(:team) { FactoryBot.create(:team) }
    let(:action) { mentor_join_requests_path(team_id: team.id) }

    before do
      Timecop.freeze(ImportantDates.quarterfinals_judging_begins - 1.day)
      sign_in(mentor)
    end

    after do
      Timecop.return
    end

    scenario "Team building enabled" do
      enable_team_building
      visit new_mentor_join_request_path(team_id: team.id)

      expect(page).to have_css("form[action='#{action}']")
    end

    scenario "Team building disabled" do
      disable_team_building
      visit new_mentor_join_request_path(team_id: team.id)

      expect(page).not_to have_css("form[action='#{action}']")
    end
  end

  context "Team building as a mentor" do
    let(:mentor) { FactoryBot.create(:mentor, :onboarded) }
    let(:team) { FactoryBot.create(:team) }
    let(:action) { new_mentor_mentor_search_path }

    before do
      Timecop.freeze(ImportantDates.quarterfinals_judging_begins - 1.day)
      TeamRosterManaging.add(team, mentor)
      sign_in(mentor)
    end

    after do
      Timecop.return
    end

    scenario "Team building enabled" do
      enable_team_building
      visit mentor_team_path(team)

      expect(page).to have_text("Do you want more teammates?")
      expect(page).to have_text("Do you want more mentors?")
    end

    scenario "Team building disabled" do
      disable_team_building
      visit mentor_team_path(team)

      expect(page).to have_text("Team building is not enabled at this time")
    end
  end
end
