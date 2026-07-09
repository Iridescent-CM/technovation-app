require "rails_helper"

RSpec.describe "Mentor::ScoresController#index performance", type: :request do
  # Baseline before optimization (local test DB):
  #   Total SQL: 66, Render: ~345ms
  #   team_submissions: 4, submission_scores: 8, judge_profiles/accounts: 28
  #
  # After optimization:
  #   Total SQL: 34, Render: ~213ms
  #   team_submissions: 1, submission_scores: 1, judge_profiles/accounts: 6

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

  def team_submission_queries(queries)
    queries.count { |sql| sql.match?(/FROM "team_submissions"/) }
  end

  def submission_score_queries(queries)
    queries.count { |sql| sql.match?(/FROM "submission_scores"/) }
  end

  def judge_or_account_queries(queries)
    queries.count { |sql| sql.match?(/FROM "(judge_profiles|accounts)"/) }
  end

  before do
    SeasonToggles.display_scores_on!
  end

  describe "GET /mentor/scores (mentor with multiple scored teams)" do
    let!(:mentor) { FactoryBot.create(:mentor, :onboarded) }

    before do
      mentor.account.took_program_survey!

      4.times do
        team = FactoryBot.create(:team)
        TeamRosterManaging.add(team, mentor)
        submission = FactoryBot.create(:submission, :complete, team: team)

        3.times do
          FactoryBot.create(:submission_score, :complete, team_submission: submission)
        end
      end
    end

    it "benchmarks index query count and render time" do
      sign_in(mentor)

      result = count_sql_queries do
        get mentor_scores_path
      end

      expect(response).to have_http_status(:ok)

      puts "\n--- Mentor scores#index benchmark ---"
      puts "Total SQL queries: #{result[:count]}"
      puts "Render time: #{(result[:elapsed] * 1000).round(1)}ms"
      puts "team_submissions queries: #{team_submission_queries(result[:queries])}"
      puts "submission_scores queries: #{submission_score_queries(result[:queries])}"
      puts "judge_profiles/accounts queries: #{judge_or_account_queries(result[:queries])}"

      expect(team_submission_queries(result[:queries])).to be <= 4
      expect(submission_score_queries(result[:queries])).to be <= 4
      expect(judge_or_account_queries(result[:queries])).to be <= 6
      expect(result[:count]).to be <= 80
    end
  end
end
