require "rails_helper"

RSpec.describe "Student::ScoresController#index performance", type: :request do
  # Baseline before optimization (local test DB):
  #   Total SQL: 94, Render: ~341ms
  #   Per-id judge_profiles/accounts: 16, Certificate team queries: 4
  #
  # After optimization:
  #   Total SQL: 32, Render: ~250ms
  #   Per-id judge_profiles/accounts: 0, Certificate team queries: 1

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

  # Per-row N+1 looks like WHERE id = $1 (not IN (...))
  def per_id_judge_or_account_queries(queries)
    queries.count { |sql|
      sql.match?(/FROM "(judge_profiles|accounts)".*WHERE.*"id" = \$1/) &&
        !sql.include?("auth_token")
    }
  end

  def certificate_team_queries(queries)
    queries.count { |sql|
      sql.match?(/FROM "teams"/) &&
        !sql.include?("memberships") &&
        sql.match?(/"teams"\."id" (IN|=)/)
    }
  end

  before do
    SeasonToggles.display_scores_on!
  end

  describe "GET /student/scores (student with many scores and previous certificates)" do
    let!(:submission) { FactoryBot.create(:submission, :complete) }
    let!(:student) { submission.team.students.sample }

    before do
      student.account.took_program_survey!

      8.times do
        FactoryBot.create(:submission_score, :complete, team_submission: submission)
      end

      4.times do |i|
        team = FactoryBot.create(:team)
        FactoryBot.create(
          :certificate,
          account: student.account,
          team: team,
          cert_type: :participation,
          season: Season.current.year - (i + 1)
        )
      end
    end

    it "benchmarks index query count and render time" do
      sign_in(student)

      result = count_sql_queries do
        get student_scores_path
      end

      expect(response).to have_http_status(:ok)

      puts "\n--- Student scores#index benchmark ---"
      puts "Total SQL queries: #{result[:count]}"
      puts "Render time: #{(result[:elapsed] * 1000).round(1)}ms"
      puts "Per-id judge_profiles/accounts queries: #{per_id_judge_or_account_queries(result[:queries])}"
      puts "Certificate team queries: #{certificate_team_queries(result[:queries])}"

      expect(per_id_judge_or_account_queries(result[:queries])).to be <= 2
      expect(certificate_team_queries(result[:queries])).to be <= 2
      expect(result[:count]).to be <= 70
    end
  end
end
