require "rails_helper"

RSpec.describe "Admin::ChapterAmbassadorsController#index performance", type: :request do
  # Baseline before optimization (local test DB, 5 chapter ambassadors):
  #   Total SQL queries: 69
  #   Render time: ~322ms
  #   Per-row chapterable assignment queries: 30
  #   Mentor profile queries: 0
  #
  # After optimization:
  #   Total SQL queries: 20
  #   Render time: ~221ms
  #   Per-row chapterable assignment queries: 2
  #   Mentor profile queries: 1

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

  def chapterable_assignment_queries(queries)
    queries.count { |sql|
      sql.match?(/FROM "chapterable_account_assignments"/)
    }
  end

  def mentor_profile_queries(queries)
    queries.count { |sql|
      sql.match?(/FROM "mentor_profiles"/)
    }
  end

  before do
    admin = FactoryBot.create(:admin)
    sign_in(admin)

    FactoryBot.create_list(:chapter_ambassador, 3)
    FactoryBot.create(:chapter_ambassador, :has_mentor_profile)
    FactoryBot.create(:chapter_ambassador, :has_mentor_profile)
  end

  describe "GET /admin/chapter_ambassadors" do
    it "benchmarks index query count and render time" do
      result = count_sql_queries do
        get admin_chapter_ambassadors_path
      end

      expect(response).to have_http_status(:ok)

      puts "\n--- Admin chapter_ambassadors#index benchmark ---"
      puts "Total SQL queries: #{result[:count]}"
      puts "Render time: #{(result[:elapsed] * 1000).round(1)}ms"
      puts "Chapterable assignment queries: #{chapterable_assignment_queries(result[:queries])}"
      puts "Mentor profile queries: #{mentor_profile_queries(result[:queries])}"

      expect(chapterable_assignment_queries(result[:queries])).to be <= 6
      expect(mentor_profile_queries(result[:queries])).to be <= 2
      expect(result[:count]).to be <= 45
    end

    it "preloads associations when rendering grid rows" do
      grid = ChapterAmbassadorsGrid.new(
        admin: true,
        allow_state_search: true,
        country: [],
        state_province: []
      )

      result = count_sql_queries do
        assets = grid.assets.to_a
        assets.each { |account| grid.row_for(account) }
      end

      expect(result[:count]).to be > 0
      puts "\n--- ChapterAmbassadorsGrid row render ---"
      puts "Total SQL queries: #{result[:count]}"
      puts "Chapterable assignment queries: #{chapterable_assignment_queries(result[:queries])}"

      expect(chapterable_assignment_queries(result[:queries])).to be <= 4
    end
  end
end
