require "rails_helper"

RSpec.describe "teams/_mentor_list.html.erb", type: :view do
  before do
    SeasonToggles.team_building_enabled!

    render partial: "teams/mentor_list.html.erb",
      locals: {
      team: team,
      current_scope: current_scope,
    }
  end

  let(:team) { FactoryBot.create(:team) }
  let(:current_scope) { "hito" }

  context "when a student is viewing this page" do
    let(:current_scope) { "student" }

    it "renders a link to the student's find a mentor page" do
      expect(rendered).to have_link(
        "Search for a mentor to invite",
        href: "/student/mentor_searches/new")
    end
  end

  context "when a mentor is viewing this page" do
    let(:current_scope) { "mentor" }

    it "renders a link to the mentor's find a mentor page" do
      expect(rendered).to have_link(
        "Search for a mentor to invite",
        href: "/mentor/mentor_searches/new")
    end
  end
end
