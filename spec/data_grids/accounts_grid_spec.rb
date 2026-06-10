require "rails_helper"

RSpec.describe AccountsGrid do
  describe "CSV export" do
    it "avoids N+1 queries when rendering association-backed columns" do
      student = FactoryBot.create(:student, :onboarded)
      mentor = FactoryBot.create(:mentor, :onboarded)
      judge = FactoryBot.create(:judge, :onboarded)

      grid = described_class.new(
        admin: true,
        country: [],
        state_province: [],
        season: Season.current.year,
        season_and_or: "match_any"
      )

      assets = grid.assets.to_a
      skip "no participants in test database" if assets.empty?

      queries = []
      subscription = ActiveSupport::Notifications.subscribe("sql.active_record") do |*, payload|
        next if payload[:name] == "SCHEMA" || payload[:sql].match?(/pg_|sqlite_/)

        queries << payload[:sql]
      end

      assets.each do |account|
        grid.row_for(account)
      end

      ActiveSupport::Notifications.unsubscribe(subscription)

      profile_queries = queries.count { |sql|
        sql.match?(/FROM "(student_profiles|mentor_profiles|judge_profiles|mentor_profile_mentor_types|judge_profile_judge_types|teams|parental_consents|background_checks|consent_waivers)"/)
      }

      expect(profile_queries).to eq(0)
      expect(assets.map(&:id)).to include(student.account.id, mentor.account.id, judge.account.id)
    end

    it "includes expected participant columns" do
      grid = described_class.new(
        admin: true,
        country: [],
        state_province: [],
        season: Season.current.year,
        season_and_or: "match_any",
        column_names: ["id", "team_names"]
      )

      header = grid.to_csv.lines.first

      expect(header).to include("Participant ID")
      expect(header).to include("Email")
      expect(header).to include("Team name(s)")
    end
  end
end
