require "rails_helper"

RSpec.describe "admin/team_submissions/_additional_questions.html.erb", type: :view do
  before do
    render partial: "admin/team_submissions/additional_questions",
      locals: {team_submission: team_submission}
  end

  let(:team_submission) { FactoryBot.build(:team_submission, seasons: [season]) }

  context "when the season is 2021" do
    let(:season) { 2021 }

    it "renders an AI question" do
      expect(rendered).to include(I18n.t("submissions.ai_question"))
    end

    it "renders a climate change question" do
      expect(rendered).to include(I18n.t("submissions.climate_change_question"))
    end

    it "renders a game-related question" do
      expect(rendered).to include(I18n.t("submissions.game_question"))
    end
  end

  context "when the season is 2022" do
    let(:season) { 2022 }

    it "renders an AI question" do
      expect(rendered).to include(I18n.t("submissions.ai_question"))
    end

    it "renders a climate change question" do
      expect(rendered).to include(I18n.t("submissions.climate_change_question"))
    end

    it "renders a health-related question" do
      expect(rendered).to include(I18n.t("submissions.solves_health_problem_question"))
    end
  end

  context "when the season is 2023" do
    let(:season) { 2023 }

    it "renders an AI question" do
      expect(rendered).to include(I18n.t("submissions.ai_question"))
    end

    it "renders a climate change question" do
      expect(rendered).to include(I18n.t("submissions.climate_change_question"))
    end

    it "renders a hunger/food waste question" do
      expect(rendered).to include(I18n.t("submissions.solves_hunger_or_food_waste_question"))
    end

    it "renders an OpenAI/ChatGPT question" do
      expect(rendered).to include(I18n.t("submissions.uses_open_ai_question"))
    end
  end
end
