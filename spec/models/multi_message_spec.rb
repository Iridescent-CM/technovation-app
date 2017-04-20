require "rails_helper"

RSpec.describe MultiMessage do
  it "handles dirty input for recipients" do
    judge = FactoryGirl.create(:judge)
    message = MultiMessage.new(recipients: {
      judge_profile: "[#{judge.id},]"
    })
    expect(message.judges).to eq([judge])

    team = FactoryGirl.create(:team)
    message = MultiMessage.new(recipients: {
      team: "[#{team.id},]"
    })
    expect(message.teams).to eq([team])
  end
end
