require "rails_helper"

RSpec.feature "Toggle selecting regional pitch events" do
  context "As a student" do
    scenario "Select another pitch event control available" do
      user = FactoryGirl.create(:student, :on_team)
      rpe = FactoryGirl.create(:rpe)

      sign_in(user)

      SeasonToggles.select_regional_pitch_event="on"
      visit student_regional_pitch_event_path(id: rpe.id)

      expect(page).to have_link("Select this event instead")

      SeasonToggles.select_regional_pitch_event="off"
      visit student_regional_pitch_event_path(id: rpe.id)

      expect(page).not_to have_link("Select this event instead")
    end

    scenario "Leave selected pitch event control available" do
      user = FactoryGirl.create(:student, :on_team)
      rpe = FactoryGirl.create(:rpe)

      rpe.teams << user.team

      sign_in(user)

      SeasonToggles.select_regional_pitch_event="on"
      visit student_regional_pitch_event_path(id: rpe.id)

      expect(page).to have_link("Remove #{user.team.name} from this event")

      SeasonToggles.select_regional_pitch_event="off"
      visit student_regional_pitch_event_path(id: rpe.id)

      expect(page).not_to have_link("Remove #{user.team.name} from this event")
    end

    scenario "Leave selected pitch event dashboard control available" do
      user = FactoryGirl.create(:student, :on_team)
      rpe = FactoryGirl.create(:rpe)
      sub = FactoryGirl.create(:submission)

      user.team.team_submissions << sub
      rpe.teams << user.team

      sign_in(user)

      SeasonToggles.select_regional_pitch_event="on"
      visit student_dashboard_path(anchor: "live-events")

      expect(page).to have_link("remove your team from this event")

      SeasonToggles.select_regional_pitch_event="off"
      visit student_dashboard_path(anchor: "live-events")

      expect(page).not_to have_link("remove your team from this event")
    end
  end

  context "As a judge" do
    scenario "Select another pitch event control available" do
      user = FactoryGirl.create(:judge)
      rpe = FactoryGirl.create(:rpe)

      sign_in(user)

      SeasonToggles.select_regional_pitch_event="on"
      visit judge_regional_pitch_event_path(id: rpe.id)

      expect(page).to have_link("Select this event instead")

      SeasonToggles.select_regional_pitch_event="off"
      visit judge_regional_pitch_event_path(id: rpe.id)

      expect(page).not_to have_link("Select this event instead")
    end

    scenario "Leave selected pitch event control available" do
      user = FactoryGirl.create(:judge)
      rpe = FactoryGirl.create(:rpe)

      rpe.judges << user

      sign_in(user)

      SeasonToggles.select_regional_pitch_event="on"
      visit judge_regional_pitch_event_path(id: rpe.id)

      expect(page).to have_link("Remove yourself from this event")

      SeasonToggles.select_regional_pitch_event="off"
      visit judge_regional_pitch_event_path(id: rpe.id)

      expect(page).not_to have_link("Remove yourself from this event")
    end

    scenario "Leave selected pitch event dashboard control available" do
      user = FactoryGirl.create(:judge, full_access: true)
      rpe = FactoryGirl.create(:rpe)

      rpe.judges << user

      sign_in(user)

      SeasonToggles.select_regional_pitch_event="on"
      visit judge_dashboard_path(anchor: "live-events")

      expect(page).to have_link("remove yourself from this event")

      SeasonToggles.select_regional_pitch_event="off"
      visit judge_dashboard_path(anchor: "live-events")

      expect(page).not_to have_link("remove yourself from this event")
    end
  end
end