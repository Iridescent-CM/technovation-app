require "rails_helper"

RSpec.feature "Auto-login to the site with your mailer token" do
  %i{student mentor}.each do |scope|
    scenario "#{scope} on their dashboard" do
      profile = FactoryGirl.create(scope)

      visit send("#{scope}_dashboard_path", mailer_token: profile.mailer_token)

      expect(current_path).to eq(send("#{scope}_dashboard_path"))

      expect(page).to have_css(
        ".flash",
        text: I18n.t("controllers.signins.create.success")
      )
    end

    scenario "#{scope} on their team page" do
      profile = FactoryGirl.create(scope, :on_team)

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
      profile = FactoryGirl.create(scope, :on_team)
      join_request = FactoryGirl.create(:join_request, team: profile.teams.first)

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

    scenario "#{scope} on invite review" do
      invite_type = scope == :student ? "team_member" : "mentor"

      profile = FactoryGirl.create(scope)

      invite = FactoryGirl.create(
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
