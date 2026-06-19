require "rails_helper"

RSpec.describe "Admin::ParticipantsController#index performance", type: :request do
  # Baseline before optimization (local test DB, ~6 participants):
  #   Total SQL queries: 37
  #   Render time: ~263ms
  #   COUNT queries on accounts: 7
  #   Chapter/club option queries: 3
  #   Association preload queries: 7
  #
  # After optimization:
  #   Total SQL queries: 11
  #   Render time: ~151ms
  #   COUNT queries on accounts: 1
  #   Chapter/club option queries: 2 (0 on warm cache)
  #   Association preload queries: 0

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

  def chapter_or_club_option_queries(queries)
    queries.count { |sql|
      sql.match?(/FROM "(chapters|clubs)"/)
    }
  end

  def assets_count_queries(queries)
    queries.count { |sql|
      sql.match?(/SELECT COUNT\(\*\) FROM "accounts"/)
    }
  end

  def preload_queries(queries)
    queries.count { |sql|
      sql.match?(/FROM "(student_profiles|mentor_profiles|judge_profiles|chapterable_account_assignments|background_checks|consent_waivers|teams)"/)
    }
  end

  before do
    admin = FactoryBot.create(:admin)
    sign_in(admin)

    FactoryBot.create_list(:student, 3, :onboarded)
    FactoryBot.create_list(:mentor, 2, :onboarded)
    FactoryBot.create(:judge, :onboarded)
    FactoryBot.create(:chapter)
    FactoryBot.create(:club)
  end

  describe "GET /admin/participants" do
    it "benchmarks index query count and render time" do
      result = count_sql_queries do
        get admin_participants_path, params: {
          accounts_grid: {
            season: Season.current.year,
            season_and_or: "match_any"
          }
        }
      end

      expect(response).to have_http_status(:ok)

      puts "\n--- Admin participants#index benchmark ---"
      puts "Total SQL queries: #{result[:count]}"
      puts "Render time: #{(result[:elapsed] * 1000).round(1)}ms"
      puts "COUNT queries on accounts: #{assets_count_queries(result[:queries])}"
      puts "Chapter/club option queries: #{chapter_or_club_option_queries(result[:queries])}"
      puts "Association preload queries: #{preload_queries(result[:queries])}"

      expect(assets_count_queries(result[:queries])).to be <= 2
      expect(chapter_or_club_option_queries(result[:queries])).to be <= 2
      expect(preload_queries(result[:queries])).to be <= 2
      expect(result[:count]).to be <= 25
    end

    it "caches chapter and club filter options across grid instances" do
      allow(Rails).to receive(:cache).and_return(ActiveSupport::Cache::MemoryStore.new)

      first_queries = count_sql_queries { AccountsGrid.chapter_filter_options }
      second_queries = count_sql_queries { AccountsGrid.chapter_filter_options }

      expect(first_queries[:count]).to eq(1)
      expect(second_queries[:count]).to eq(0)
    end
  end
end
