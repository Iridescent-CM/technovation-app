require "rails_helper"

RSpec.describe "Admin::ParticipantsController#show performance", type: :request do
  # Baseline before optimization (local test DB):
  #   Judge — Total SQL: 68, Render: ~3861ms, team_submission/team queries: 28
  #   Student — Total SQL: 47, Render: ~261ms, chapterable queries: 13
  #
  # After optimization:
  #   Judge — Total SQL: 51, Render: ~287ms, team_submission/team queries: 6
  #   Student — Total SQL: 39, Render: ~199ms, chapterable queries: 14

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

  def team_association_queries(queries)
    queries.count { |sql|
      sql.match?(/FROM "(team_submissions|teams)"/)
    }
  end

  def chapterable_association_queries(queries)
    queries.count { |sql|
      sql.match?(/FROM "(chapterable_account_assignments|chapters|clubs)"/)
    }
  end

  before do
    admin = FactoryBot.create(:admin)
    sign_in(admin)
  end

  describe "GET /admin/participants/:id (judge with scores)" do
    let!(:judge) { FactoryBot.create(:judge, :onboarded) }

    before do
      8.times do
        FactoryBot.create(:score, :complete, :quarterfinals, judge_profile: judge)
      end

      4.times do
        FactoryBot.create(:score, :complete, :semifinals, judge_profile: judge)
      end

      2.times do
        FactoryBot.create(
          :score,
          :quarterfinals,
          judge_profile: judge,
          judge_recusal: true,
          judge_recusal_reason: "knows_team"
        )
      end
    end

    it "benchmarks show query count and render time" do
      result = count_sql_queries do
        get admin_participant_path(judge.account)
      end

      expect(response).to have_http_status(:ok)

      puts "\n--- Admin participants#show benchmark (judge) ---"
      puts "Total SQL queries: #{result[:count]}"
      puts "Render time: #{(result[:elapsed] * 1000).round(1)}ms"
      puts "Team/submission association queries: #{team_association_queries(result[:queries])}"

      expect(team_association_queries(result[:queries])).to be <= 8
      expect(result[:count]).to be <= 55
    end
  end

  describe "GET /admin/participants/:id (student with chapter and team)" do
    let(:chapter) { FactoryBot.create(:chapter) }
    let(:co_mentor) { FactoryBot.create(:mentor, :onboarded) }
    let!(:student) { FactoryBot.create(:student, :onboarded, :on_team, :not_assigned_to_chapter) }

    before do
      student.chapterable_assignments.create!(
        account: student.account,
        chapterable: chapter,
        season: Season.current.year,
        primary: true
      )

      team = student.team
      TeamRosterManaging.add(team, co_mentor)
    end

    it "benchmarks show query count and render time" do
      result = count_sql_queries do
        get admin_participant_path(student.account)
      end

      expect(response).to have_http_status(:ok)

      puts "\n--- Admin participants#show benchmark (student) ---"
      puts "Total SQL queries: #{result[:count]}"
      puts "Render time: #{(result[:elapsed] * 1000).round(1)}ms"
      puts "Chapterable association queries: #{chapterable_association_queries(result[:queries])}"

      expect(chapterable_association_queries(result[:queries])).to be <= 16
      expect(result[:count]).to be <= 45
    end
  end
end
