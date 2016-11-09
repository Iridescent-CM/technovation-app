require "rails_helper"

RSpec.feature "Authentication" do
  { judge: %i{mentor regional_ambassador student admin},
    student: %i{mentor regional_ambassador judge admin},
    mentor: %i{judge regional_ambassador student admin},
    regional_ambassador: %i{mentor judge student admin} }.each do |type, not_types|
      not_types.each do |not_type|
        scenario "A #{type} tries to visit a #{not_type} path" do
          account = FactoryGirl.create(type)

          sign_in(account)
          visit send("#{not_type}_dashboard_path")

          expect(page).to have_current_path(send("#{type}_dashboard_path"))
          expect(page).to have_css(".flash", text: "You don't have permission to go there")
        end
      end
    end

    %i{mentor student judge regional_ambassador admin}.each do |type|
      scenario "A logged out user tries to visit a #{type} path" do
        visit send("#{type}_dashboard_path")

        expect(page).to have_current_path(signin_path)
        expect(page).to have_css(".flash", text: "You must be signed in as #{type.indefinitize.humanize.downcase} to go there!")
      end
    end
end
