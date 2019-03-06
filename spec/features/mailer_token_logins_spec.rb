require "rails_helper"

RSpec.feature "Auto-login to the site with your mailer token" do
  %i{student mentor}.each do |scope|
    before { SeasonToggles.enable_team_building! }

    scenario "#{scope} on their dashboard" do
      profile = FactoryBot.create(scope)

      visit send("#{scope}_dashboard_path", mailer_token: profile.mailer_token)

      expect(current_path).to eq(send("#{scope}_dashboard_path"))

      expect(page).to have_css(
        ".flash",
        text: I18n.t("controllers.signins.create.success")
      )
    end

    scenario "#{scope} on their team page" do
      profile = FactoryBot.create(scope, :on_team)

      visit send(
        "#{scope}_team_path",
        profile.teams.first,
        mailer_token: profile.mailer_token
      )

      expect(current_path).to eq(send("#{scope}_team_path", profile.teams.first))

      expect(page).to have_css(
        ".flash",
        text: I18n.t("controllers.signins.create.success")
      )
    end

    scenario "#{scope} on join request review" do
      Timecop.freeze(ImportantDates.quarterfinals_judging_begins - 1.day) do
        profile = FactoryBot.create(scope, :on_team)
        join_request = FactoryBot.create(:join_request, team: profile.teams.first)

        visit send(
          "#{scope}_join_request_path",
          join_request,
          mailer_token: profile.mailer_token
        )

        expect(current_path).to eq(send("#{scope}_join_request_path", join_request))

        expect(page).to have_css(
          ".flash",
          text: I18n.t("controllers.signins.create.success")
        )
      end
    end

    scenario "#{scope} on invite review" do
      Timecop.freeze(ImportantDates.quarterfinals_judging_begins - 1.day) do
        invite_type = scope == :student ? "team_member" : "mentor"
        trait = scope == :mentor ? :onboarded : :onboarding

        profile = FactoryBot.create(scope, trait)

        invite = FactoryBot.create(
          "#{invite_type}_invite",
          invitee_email: profile.email
        )

        visit send(
          "#{scope}_#{invite_type}_invite_path",
          invite,
          mailer_token: profile.mailer_token
        )

        expect(current_path).to eq(
          send("#{scope}_#{invite_type}_invite_path", invite)
        )

        expect(page).to have_css(
          ".flash",
          text: I18n.t("controllers.signins.create.success")
        )
      end
    end
  end
end
