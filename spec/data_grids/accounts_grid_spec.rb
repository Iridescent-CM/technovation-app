require "rails_helper"

RSpec.describe AccountsGrid do
  describe "CSV export" do
    it "avoids N+1 queries when rendering association-backed columns" do
      students = FactoryBot.create_list(:student, 3, :onboarded)
      mentor = FactoryBot.create(:mentor, :onboarded)
      judge = FactoryBot.create(:judge, :onboarded)

      grid = described_class.new(
        admin: true,
        country: [],
        state_province: [],
        season: Season.current.year,
        season_and_or: "match_any",
        column_names: %w[
          id profile_type chapter club mentor_types mentor_expertise
          judge_types team_division team_names background_check
          invitation_status parental_consent media_consent consent_waiver
          virtual_or_live
        ]
      )

      queries = []
      subscription = ActiveSupport::Notifications.subscribe("sql.active_record") do |*, payload|
        next if payload[:name] == "SCHEMA" || payload[:sql].match?(/pg_|sqlite_/)

        queries << payload[:sql]
      end

      exported_ids = []
      grid.send(:each_with_batches) do |account|
        grid.row_for(account)
        exported_ids << account.id
      end

      ActiveSupport::Notifications.unsubscribe(subscription)

      association_query_counts = queries.each_with_object(Hash.new(0)) { |sql, counts|
        table = sql[/(?<=FROM ")[^"]+/]
        counts[table] += 1 if %w[
          divisions student_profiles mentor_profiles judge_profiles
          mentor_profile_mentor_types judge_profile_judge_types teams
          parental_consents background_checks consent_waivers
        ].include?(table)
      }

      expect(association_query_counts.values).to all(be <= 2)
      expect(exported_ids).to include(
        *students.map(&:account_id),
        mentor.account.id,
        judge.account.id
      )
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

    it "renders country names without external geocoding requests" do
      account = Account.new(
        first_name: "Ada",
        last_name: "Lovelace",
        email: "ada@example.com",
        country: "US"
      )
      grid = described_class.new(
        admin: true,
        country: [],
        state_province: [],
        column_names: ["country"]
      )

      expect(Geocoder).not_to receive(:search)

      country_index = grid.header.index("Country")
      expect(grid.row_for(account)[country_index]).to eq("United States")
    end
  end
end
