require "rails_helper"

RSpec.describe SubmissionsHelper do
  describe "#additional_question_labels" do
    let(:submission) { TeamSubmission.new(seasons: [season]) }

    context "when the season is 2021" do
      let(:season) { [2021] }

      it "returns :ai, :climate_change, and :game" do
        expect(additional_question_labels(submission)).to include(:ai)
        expect(additional_question_labels(submission)).to include(:climate_change)
        expect(additional_question_labels(submission)).to include(:game)
      end
    end

    context "when the season is 2022" do
      let(:season) { [2022] }

      it "returns :ai, :climate_change, and :solves_health_problem" do
        expect(additional_question_labels(submission)).to include(:ai)
        expect(additional_question_labels(submission)).to include(:climate_change)
        expect(additional_question_labels(submission)).to include(:solves_health_problem)
      end
    end

    context "when the season is 2023" do
      let(:season) { [2023] }

      it "returns :ai, :climate_change, :solves_hunger_or_food_waste, and :uses_open_ai" do
        expect(additional_question_labels(submission)).to include(:ai)
        expect(additional_question_labels(submission)).to include(:climate_change)
        expect(additional_question_labels(submission)).to include(:solves_hunger_or_food_waste)
        expect(additional_question_labels(submission)).to include(:uses_open_ai)
      end
    end

    context "when the season is 2024" do
      let(:season) { [2024] }

      it "returns :ai, :climate_change, :solves_hunger_or_food_waste, :uses_open_ai, :solves_education" do
        expect(additional_question_labels(submission)).to include(:ai)
        expect(additional_question_labels(submission)).to include(:climate_change)
        expect(additional_question_labels(submission)).to include(:solves_hunger_or_food_waste)
        expect(additional_question_labels(submission)).to include(:uses_open_ai)
        expect(additional_question_labels(submission)).to include(:solves_education)
      end
    end

    context "when the season is 2025" do
      let(:season) { [2025] }

      it "returns :ai, :climate_change, :solves_hunger_or_food_waste, :uses_open_ai, :solves_education, :uses_gadgets" do
        expect(additional_question_labels(submission)).to include(:ai)
        expect(additional_question_labels(submission)).to include(:climate_change)
        expect(additional_question_labels(submission)).to include(:solves_hunger_or_food_waste)
        expect(additional_question_labels(submission)).to include(:uses_open_ai)
        expect(additional_question_labels(submission)).to include(:solves_education)
        expect(additional_question_labels(submission)).to include(:uses_gadgets)
      end
    end
  end
end
