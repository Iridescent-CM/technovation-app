require "spec_helper"

RSpec.describe "Circle CI Brakeman config" do
  it "runs Brakeman as a CI step" do
    circle_src = File.read("./circle.yml")

    expect(circle_src).to include("Run Brakeman")
    expect(circle_src).to match(/bundle exec brakeman.*--exit-on-warn.*--exit-on-error/m)
  end
end
