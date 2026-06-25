require "rails_helper"

RSpec.describe MentorsGrid do
  describe "team_matching filter" do
    let(:matched_mentor) { FactoryBot.create(:mentor, :onboarded, :on_team) }
    let(:unmatched_mentor) { FactoryBot.create(:mentor, :onboarded) }
    let(:matched_student) { FactoryBot.create(:student, :on_team) }

    def mentor_grid(**params)
      described_class.new(
        admin: true,
        season: Season.current.year,
        **params
      )
    end

    it "returns matched mentors without error" do
      matched_mentor
      unmatched_mentor
      matched_student

      grid = mentor_grid(team_matching: "matched")
      assets = grid.assets.to_a

      expect(assets.map(&:id)).to include(matched_mentor.account.id)
      expect(assets.map(&:id)).not_to include(unmatched_mentor.account.id)
      expect(assets.map(&:id)).not_to include(matched_student.account.id)
    end

    it "returns unmatched mentors without error" do
      matched_mentor
      unmatched_mentor
      matched_student

      grid = mentor_grid(team_matching: "unmatched")
      assets = grid.assets.to_a

      expect(assets.map(&:id)).to include(unmatched_mentor.account.id)
      expect(assets.map(&:id)).not_to include(matched_mentor.account.id)
      expect(assets.map(&:id)).not_to include(matched_student.account.id)
    end

    it "returns matched onboarded mentors without error" do
      matched_mentor
      unmatched_mentor

      grid = mentor_grid(
        onboarded_mentors: "onboarded",
        team_matching: "matched"
      )
      assets = grid.assets.to_a

      expect(assets.map(&:id)).to include(matched_mentor.account.id)
      expect(assets.map(&:id)).not_to include(unmatched_mentor.account.id)
    end

    it "returns unmatched onboarded mentors without error" do
      matched_mentor
      unmatched_mentor

      grid = mentor_grid(
        onboarded_mentors: "onboarded",
        team_matching: "unmatched"
      )
      assets = grid.assets.to_a

      expect(assets.map(&:id)).to include(unmatched_mentor.account.id)
      expect(assets.map(&:id)).not_to include(matched_mentor.account.id)
    end
  end
end
