require "spec_helper"
require "./app/technovation/profile_completion/link"

RSpec.describe ProfileCompletion::Link do
  it "matches a url to the config map" do
    link = ProfileCompletion::Link.new("step_id", "link_name")
    urls = {
      step_id: {
        other_link: "not url",
        link_name: "url",
      },
    }

    expect(link.url(urls)).to eq("url")
  end
end
