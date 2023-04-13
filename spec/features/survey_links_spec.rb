require "rails_helper"

RSpec.feature "Survey links" do
  %i[student mentor].each do |scope|
    before do
      SeasonToggles.set_survey_link(scope, "survey", "http")

      allow(ImportantDates).to receive(:new_season_switch).and_return(Date.new(2020, 1, 1))
    end

    scenario "a new #{scope} waits 2 days from profile creation" do
      user = FactoryBot.create(scope)

      sign_in(user)
      expect(page).not_to have_css("#survey-modal")

      Timecop.travel(2.days.from_now) do
        visit send("#{scope}_dashboard_path")
        expect(page).to have_css("#survey-modal")
      end
    end

    scenario "an existing #{scope} waits 2 days from season registration" do
      user = FactoryBot.create(scope)

      user.account.update_columns(
        seasons: [Season.current.year - 1],
        created_at: 1.year.ago,
        updated_at: 1.year.ago
      )

      user.update_columns(
        created_at: 1.year.ago,
        updated_at: 1.year.ago
      )

      sign_in(user) # Signing in registers to the season
      expect(page).not_to have_css("#survey-modal")

      Timecop.travel(2.days.from_now) do
        visit send("#{scope}_dashboard_path")
        expect(page).to have_css("#survey-modal")
      end
    end

    scenario "all #{scope}s get reminded in 2 more days" do
      user = FactoryBot.create(scope)

      sign_in(user)
      expect(page).not_to have_css("#survey-modal")

      Timecop.travel(2.days.from_now) do
        visit send("#{scope}_dashboard_path")
        expect(page).to have_css("#survey-modal")

        user.account.reminded_about_survey!
        visit send("#{scope}_dashboard_path")
        expect(page).not_to have_css("#survey-modal")

        Timecop.travel(2.days.from_now) do
          visit send("#{scope}_dashboard_path")
          expect(page).to have_css("#survey-modal")
        end
      end
    end

    scenario "no #{scope}s get reminded after the 2nd time" do
      user = FactoryBot.create(scope)

      sign_in(user)
      expect(page).not_to have_css("#survey-modal")

      Timecop.travel(2.days.from_now) do
        visit send("#{scope}_dashboard_path")
        expect(page).to have_css("#survey-modal")

        user.account.reminded_about_survey!
        visit send("#{scope}_dashboard_path")
        expect(page).not_to have_css("#survey-modal")

        Timecop.travel(2.days.from_now) do
          visit send("#{scope}_dashboard_path")
          expect(page).to have_css("#survey-modal")

          user.account.reminded_about_survey!
          visit send("#{scope}_dashboard_path")
          expect(page).not_to have_css("#survey-modal")

          Timecop.travel(2.days.from_now) do
            visit send("#{scope}_dashboard_path")
            expect(page).not_to have_css("#survey-modal")
          end
        end
      end
    end

    scenario "no reminders or links appear for those who took the survey" do
      user = FactoryBot.create(scope)
      user.account.took_program_survey!

      sign_in(user)

      Timecop.travel(2.days.from_now) do
        visit send("#{scope}_dashboard_path")
        expect(page).not_to have_css("#survey-modal")
      end
    end
  end
end
