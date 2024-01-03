require "rails_helper"

RSpec.describe TeamController do
  %w[admin mentor student].each do |scope|
    describe "#{scope.capitalize}::TeamsController".constantize do
      describe "PATCH #update" do
        it "geocodes teams on city/state/country changes" do
          team = FactoryBot.create(:team, :geocoded)

          profile = if scope == "mentor"
            FactoryBot.create(scope, :onboarded)
          else
            FactoryBot.create(scope)
          end

          unless scope == "admin"
            TeamRosterManaging.add(team, profile)
          end

          sign_in(profile)

          patch :update, params: {
            id: team.id,
            team: {
              city: "Los Angeles",
              state_province: "CA"
            }
          }

          team.reload
          expect(team.latitude).to eq(34.052363)
          expect(team.longitude).to eq(-118.256551)
        end
      end
    end
  end
end
