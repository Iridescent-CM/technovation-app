require "rails_helper"

RSpec.describe TeamSubmission do
  subject { TeamSubmission.new }

  it { should respond_to(:stated_goal) }
  it { should respond_to(:stated_goal_explanation) }

  it "has a defined list of Sustainabel Development Goals (SDG)" do
    goals = TeamSubmission.stated_goals.keys

    expect(goals).to match_array(
      %w{Poverty Environment Peace Equality Education Health}
    )
  end
end
