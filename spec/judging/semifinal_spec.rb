require 'rails_helper'

RSpec.describe "Selecting team to judge for semifinal" do

  context "for semifinalist judge" do
    subject { Semifinal.new.teams_to_judge(judge) }

    let(:judge) { double(:judge, semifinals_judge?: true) }
    let(:semifinalist_team) { create(:team, is_semi_finalist: true) }
    let(:not_semifinalist_team) { create(:team, is_semi_finalist: false) }

    it "selects semifinalist teams" do
      is_expected.to eq([semifinalist_team])
    end
  end

  context "for non semifinalist judge" do
    subject { Semifinal.new.teams_to_judge(judge) }

    let(:judge) { double(:judge, semifinals_judge?: false) }

    it "does not show any team" do
      is_expected.to be_empty
    end
  end

end
