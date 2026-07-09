require "rails_helper"

RSpec.describe "Mentor::CertificatesController#index performance", type: :request do
  # Baseline before optimization (local test DB):
  #   Total SQL: 37, Render: ~152ms, teams queries: 10
  #
  # After optimization:
  #   Total SQL: 29, Render: ~134ms, teams queries: 2

  def count_sql_queries
    queries = []
    subscription = ActiveSupport::Notifications.subscribe("sql.active_record") do |*, payload|
      next if payload[:name] == "SCHEMA"
      next if payload[:sql].match?(/pg_|sqlite_|SAVEPOINT|RELEASE SAVEPOINT/)

      queries << payload[:sql]
    end

    elapsed = Benchmark.realtime { yield }

    ActiveSupport::Notifications.unsubscribe(subscription)

    {queries: queries, count: queries.size, elapsed: elapsed}
  end

  def teams_queries(queries)
    queries.count { |sql| sql.match?(/FROM "teams"/) }
  end

  before do
    SeasonToggles.display_scores_on!
  end

  describe "GET /mentor/certificates (mentor with current and previous certificates)" do
    let!(:mentor) { FactoryBot.create(:mentor, :onboarded) }

    before do
      mentor.account.took_program_survey!

      5.times do
        team = FactoryBot.create(:team)
        FactoryBot.create(
          :certificate,
          account: mentor.account,
          team: team,
          cert_type: :mentor,
          season: Season.current.year
        )
      end

      5.times do |i|
        team = FactoryBot.create(:team)
        FactoryBot.create(
          :certificate,
          account: mentor.account,
          team: team,
          cert_type: :mentor,
          season: Season.current.year - (i + 1)
        )
      end
    end

    it "benchmarks index query count and render time" do
      sign_in(mentor)

      result = count_sql_queries do
        get mentor_certificates_path
      end

      expect(response).to have_http_status(:ok)

      puts "\n--- Mentor certificates#index benchmark ---"
      puts "Total SQL queries: #{result[:count]}"
      puts "Render time: #{(result[:elapsed] * 1000).round(1)}ms"
      puts "teams queries: #{teams_queries(result[:queries])}"

      expect(teams_queries(result[:queries])).to be <= 4
      expect(result[:count]).to be <= 50
    end
  end
end
