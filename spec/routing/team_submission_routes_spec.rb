require "rails_helper"

RSpec.describe "GET /team_submission_pieces/:piece" do
  it "requires you to sign in" do
    expect(get: "/team_submission_pieces/app_name").to route_to(
      controller: "signins",
      action: "new",
    )
  end
end
