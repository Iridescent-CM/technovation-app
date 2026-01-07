require "rails_helper"

RSpec.describe DataProcessors::AssignJudgesToRegionalPitchEvent do
  let(:assign_judges_to_regional_pitch_event_service) do
    DataProcessors::AssignJudgesToRegionalPitchEvent.new(regional_pitch_event:,
      judge_ids:)
  end

  let(:regional_pitch_event) { FactoryBot.create(:regional_pitch_event) }
  let(:judge_ids) { [judge_1.id, judge_2.id, judge_3.id] }
  let(:judge_1) { FactoryBot.create(:judge) }
  let(:judge_2) { FactoryBot.create(:judge) }
  let(:judge_3) { FactoryBot.create(:judge) }

  it "assigns judges to the RPE" do
    assign_judges_to_regional_pitch_event_service.call

    expect(regional_pitch_event.judges.map(&:name)).to include(judge_1.name)
    expect(regional_pitch_event.judges.map(&:name)).to include(judge_2.name)
    expect(regional_pitch_event.judges.map(&:name)).to include(judge_3.name)
  end

  context "when a judge id doesn't exist" do
    before do
      judge_1.id = 800_008
    end

    it "doesn't add the judge to the RPE" do
      result = assign_judges_to_regional_pitch_event_service.call

      expect(regional_pitch_event.judges).not_to include(judge_1)
      expect(result.results).to include("Could not find judge with ID: #{judge_1.id}")
    end
  end

  context "when a judge is not in the current season" do
    before do
      judge_1.account.update(seasons: [2012])
    end

    it "doesn't add the judge to the RPE" do
      result = assign_judges_to_regional_pitch_event_service.call

      expect(regional_pitch_event.judges).not_to include(judge_1)
      expect(result.results).to include("#{judge_1.name} is not a part of the current season")
    end
  end

  context "when a judge is already assigned to this RPE" do
    before do
      judge_1.events << regional_pitch_event
    end

    it "doesn't reassign the judge to the RPE" do
      expect(regional_pitch_event.judges).to include(judge_1)

      result = assign_judges_to_regional_pitch_event_service.call

      expect(regional_pitch_event.judges.count).to eq(judge_ids.length)
      expect(result.results).to include("#{judge_1.name} has already been assigned to this event")
    end
  end
end
