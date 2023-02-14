require "rails_helper"

RSpec.feature "Students view rpe details", js: true do

  context "Student's team is registered for an RPE" do
    before do
      @rpe = FactoryBot.create(:rpe)
      @submission = FactoryBot.create(:team_submission, :junior, :complete)
      @student = @submission.team.students.sample
      @submission.team.regional_pitch_events << @rpe
    end

    scenario "Judging is off" do
      SeasonToggles.judging_round = :off

      sign_in(@student)

      find("span", text: "Pitch your project").click

      expect(page).to have_content("You are attending #{@rpe.name}.")
      expect(page).to have_link("View full details")
    end

    scenario "Judging is set to quarterfinals" do
      SeasonToggles.judging_round = :qf

      sign_in(@student)

      find("span", text: "Pitch your project").click

      expect(page).to have_content("You are attending #{@rpe.name}.")
      expect(page).to have_link("View full details")
    end
  end

  context "Student's team is not registered for an RPE" do
    before do
      @rpe = FactoryBot.create(:event, :chicago, :junior)
      @submission = FactoryBot.create(:team_submission, :chicago, :junior)
      @student = @submission.team.students.sample
    end

    scenario "Judging is off and selecting an event is disabled" do
      SeasonToggles.judging_round = :off
      SeasonToggles.select_regional_pitch_event_off!

      sign_in(@student)

      find("span", text: "Pitch your project").click

      expect(page).to have_content("Selecting an event is not available right now.")
    end

    scenario "Judging is off and selecting an event is enabled" do
      SeasonToggles.judging_round = :off
      SeasonToggles.select_regional_pitch_event_on!

      sign_in(@student)

      find("span", text: "Pitch your project").click

      expect(page).to have_content("Attend a pitching event in your area to pitch your submission to a live panel of judges!")
      expect(page).to have_link("Select an Event")
    end

    scenario "Judging is set to quarterfinals" do
      # When judging is on, RPE selection is automatically disabled
      SeasonToggles.judging_round = :qf

      sign_in(@student)

      find("span", text: "Pitch your project").click

      expect(page).to have_content("Selecting an event is not available right now.")
    end
  end
end
