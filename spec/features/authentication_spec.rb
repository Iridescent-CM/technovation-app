require "rails_helper"

RSpec.feature "Authentication" do
  def reload_cookie_names
    # daily server restart causes reload IRL, here we have to force re-evaluation of constants
    Object.send(:remove_const, "CookieNames")
    load "cookie_names.rb"
  end

  {judge: %i[chapter_ambassador student admin],
   student: %i[mentor chapter_ambassador judge admin],
   mentor: %i[chapter_ambassador student admin],
   chapter_ambassador: %i[student admin]}.each do |scope, not_scopes|
    not_scopes.each do |not_scope|
      scenario "A #{scope} tries to visit a #{not_scope} path" do
        account = FactoryBot.create(scope)

        sign_in(account)
        visit send("#{not_scope}_dashboard_path")

        expect(current_path.sub(/\?.+$/, "")).to eq(
          send("#{scope}_dashboard_path")
        )

        expect(page).to have_css(
          ".flash",
          text: "You don't have permission to go there"
        )
      end
    end
  end

  %i[mentor student judge chapter_ambassador admin].each do |scope|
    scenario "A logged out user tries to visit a #{scope} path" do
      visit send("#{scope}_dashboard_path")

      expect(page).to have_current_path(signin_path)
      expect(page).to have_css(".flash", text: "You must be signed in as #{scope.indefinitize.humanize.downcase} to go there!")
    end

    scenario "A logged in #{scope} tries to visit a path after the season changes" do
      Timecop.freeze(ImportantDates.new_season_switch - 1.day) do
        reload_cookie_names

        account = FactoryBot.create(scope)

        sign_in(account)
        visit send("#{scope}_dashboard_path")

        expect(page).to have_current_path(send("#{scope}_dashboard_path"), ignore_query: true)
      end

      Timecop.freeze(ImportantDates.new_season_switch) do
        reload_cookie_names

        visit send("#{scope}_dashboard_path")
        expect(page).to have_current_path(signin_path)
      end
    end
  end
end
