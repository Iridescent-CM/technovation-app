require "rails_helper"

RSpec.describe SeasonSetup::ForceChapterableSelectionActivator do
  let(:force_chapterable_selection_activator) { SeasonSetup::ForceChapterableSelectionActivator.new }

  context "when it's a mentor" do
    let!(:mentor) { FactoryBot.create(:mentor) }

    it "sets `force_chapterable_selection` to true" do
      force_chapterable_selection_activator.call

      expect(mentor.reload.force_chapterable_selection?).to eq(true)
    end
  end

  context "when it's a student" do
    let!(:student) { FactoryBot.create(:student) }

    it "sets `force_chapterable_selection` to true" do
      force_chapterable_selection_activator.call

      expect(student.reload.force_chapterable_selection?).to eq(true)
    end
  end

  context "when it's a judge" do
    let!(:judge) { FactoryBot.create(:judge) }

    it "does not set `force_chapterable_selection` to true" do
      force_chapterable_selection_activator.call

      expect(judge.reload.force_chapterable_selection?).to eq(false)
    end
  end

  context "when it's a chapter ambassador" do
    let!(:chapter_ambassador) { FactoryBot.create(:chapter_ambassador) }

    it "does not set `force_chapterable_selection` to true" do
      force_chapterable_selection_activator.call

      expect(chapter_ambassador.reload.force_chapterable_selection?).to eq(false)
    end
  end

  context "when it's a club ambassador" do
    let!(:club_ambassador) { FactoryBot.create(:club_ambassador) }

    it "does not set `force_chapterable_selection` to true" do
      force_chapterable_selection_activator.call

      expect(club_ambassador.reload.force_chapterable_selection?).to eq(false)
    end
  end
end
