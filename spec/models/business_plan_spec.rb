require "rails_helper"

RSpec.describe BusinessPlan do
  it "prepends urls with http:// if it's not there" do
    b = BusinessPlan.new
    b.remote_file_url = "joesak.com"
    expect(b.remote_file_url).to eq("http://joesak.com")

    b.remote_file_url = "http://joesak.com"
    expect(b.remote_file_url).to eq("http://joesak.com")

    b.remote_file_url = "https://joesak.com"
    expect(b.remote_file_url).to eq("https://joesak.com")

    b.remote_file_url = "hts://joesak.com"
    expect(b.remote_file_url).to eq("http://joesak.com")

    b.remote_file_url = ""
    expect(b.remote_file_url).to be_blank
  end
end
