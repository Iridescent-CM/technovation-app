require "rails_helper"

RSpec.describe "team_searches/_result.html.erb", type: :view do
  before do
    render partial: "team_searches/result.html.erb",
      locals: {
        team: team,
        current_scope: current_scope,
        current_profile: current_profile
      }
  end

  let(:team) do
    instance_double(Team,
      id: 1,
      name: "Awesome Team",
      primary_location: "Drogheda, Ireland",
      team_photo_url: "/images/amazing-team.jpg",
      division: division,
      spot_available?: spot_available_on_team)
  end
  let(:division) { double("division", name: "Senior") }
  let(:spot_available_on_team) { true }

  let(:current_scope) { "student" }
  let(:current_profile) do
    instance_double(StudentProfile, teams_that_declined: teams_that_declined_current_profile)
  end
  let(:teams_that_declined_current_profile) { [] }

  it "displays the team's name" do
    expect(rendered).to include("Awesome Team")
  end

  it "displays the team's location" do
    expect(rendered).to include("Drogheda, Ireland")
  end

  it "displays the team's division" do
    expect(rendered).to include("Senior")
  end

  it "displays a 'View more details' button" do
    expect(rendered).to have_link("View more details", class: "button")
  end

  context "when the team has already declined the current user/profile" do
    let(:teams_that_declined_current_profile) { [team] }

    it "displays a 'declined' message" do
      expect(rendered).to include("You asked to join Awesome Team, and they declined.")
    end
  end

  context "when there are no available spots left on the team" do
    let(:spot_available_on_team) { false }

    it "displays a 'team is full' message" do
      expect(rendered).to include("This team is currently full")
    end

    it "disables the 'View more details' button" do
      expect(rendered).to have_link("View more details", class: "button disabled")
    end
  end
end
