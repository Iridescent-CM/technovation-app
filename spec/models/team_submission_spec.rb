require "rails_helper"

RSpec.describe TeamSubmission do
  subject { TeamSubmission.new }

  it { should respond_to(:app_name) }
  it { should respond_to(:demo_video_link) }
  it { should respond_to(:pitch_video_link) }
  it { should respond_to(:stated_goal) }
  it { should respond_to(:stated_goal_explanation) }

  it "has a defined list of Sustainabel Development Goals (SDG)" do
    goals = TeamSubmission.stated_goals.keys

    expect(goals).to match_array(
      %w{Poverty Environment Peace Equality Education Health}
    )
  end

  it "prepends urls with http:// if it's not there" do
    subject.source_code_external_url = "joesak.com"
    expect(subject.source_code_external_url).to eq("http://joesak.com")

    subject.source_code_external_url = "http://joesak.com"
    expect(subject.source_code_external_url).to eq("http://joesak.com")

    subject.source_code_external_url = "https://joesak.com"
    expect(subject.source_code_external_url).to eq("https://joesak.com")

    subject.source_code_external_url = "ht://joesak.com"
    expect(subject.source_code_external_url).to eq("http://joesak.com")
  end
end
