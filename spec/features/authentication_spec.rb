require "rails_helper"

RSpec.feature "Authentication" do
  { judge: %i{regional_ambassador student admin},
    student: %i{mentor regional_ambassador judge admin},
    mentor: %i{regional_ambassador student admin},
    regional_ambassador: %i{judge student admin} }.each do |scope, not_scopes|

    not_scopes.each do |not_scope|
      scenario "A #{scope} tries to visit a #{not_scope} path" do
        account = FactoryBot.create(scope)

        sign_in(account)
        visit send("#{not_scope}_dashboard_path")

        expect(current_path.sub(/\?.+$/, "")).to eq(send("#{scope}_dashboard_path"))
        expect(page).to have_css(".flash", text: "You don't have permission to go there")
      end
    end
  end

  %i{mentor student judge regional_ambassador admin}.each do |scope|
    scenario "A logged out user tries to visit a #{scope} path" do
      visit send("#{scope}_dashboard_path")

      expect(page).to have_current_path(signin_path)
      expect(page).to have_css(".flash", text: "You must be signed in as #{scope.indefinitize.humanize.downcase} to go there!")
    end
  end
end
