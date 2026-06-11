require "rails_helper"

RSpec.describe ScoresGrid do
  describe "pagination with filters applied" do
    it "paginates after filters so all matching scores are reachable across pages" do
      SeasonToggles.set_judging_round("between")

      matching_scores = SubmissionScore.judge_not_deleted
        .quarterfinals
        .virtual
        .complete
        .by_season(Season.current.year)

      next if matching_scores.count <= 1

      grid = described_class.new(
        round: "quarterfinals",
        season: Season.current.year,
        live_or_virtual: "virtual",
        complete: "complete"
      )

      paginated_grid = grid
      paginated_grid.define_singleton_method(:assets) do
        super().page(1)
      end

      first_page_ids = paginated_grid.assets.map(&:id).uniq
      all_page_ids = matching_scores.paginate(page: 1).map(&:id).uniq

      expect(first_page_ids).to match_array(all_page_ids)

      if matching_scores.count > first_page_ids.size
        paginated_grid.define_singleton_method(:assets) do
          super().page(2)
        end

        second_page_ids = paginated_grid.assets.map(&:id).uniq
        expect(first_page_ids | second_page_ids).to match_array(matching_scores.pluck(:id))
      end
    ensure
      SeasonToggles.clear_judging_round
    end
  end

  describe "eager loading" do
    it "avoids N+1 queries for regional pitch events when rendering columns" do
      SeasonToggles.set_judging_round("between")

      grid = described_class.new(
        round: "quarterfinals",
        season: Season.current.year,
        live_or_virtual: "virtual",
        complete: "complete"
      )
      paginated_grid = grid
      paginated_grid.define_singleton_method(:assets) { super().page(1) }

      assets = paginated_grid.assets.to_a
      next if assets.empty?

      queries = []
      subscription = ActiveSupport::Notifications.subscribe("sql.active_record") do |*, payload|
        next if payload[:name] == "SCHEMA" || payload[:sql].match?(/pg_|sqlite_/)

        queries << payload[:sql]
      end

      assets.each do |score|
        score.team.event.name
        score.official
        score.judge_profile.name
        score.team_submission.app_name
      end

      ActiveSupport::Notifications.unsubscribe(subscription)

      regional_pitch_event_queries = queries.count { |sql| sql.include?("regional_pitch_events") }
      expect(regional_pitch_event_queries).to eq(0)
    ensure
      SeasonToggles.clear_judging_round
    end
  end

  describe "total column rendering" do
    it "caches judge question lookups per season and division" do
      SeasonToggles.set_judging_round("between")

      grid = described_class.new(
        round: "quarterfinals",
        season: Season.current.year,
        live_or_virtual: "virtual",
        complete: "complete"
      )
      paginated_grid = grid
      paginated_grid.define_singleton_method(:assets) { super().page(1) }

      assets = paginated_grid.assets.to_a
      next if assets.empty?

      SubmissionScore.instance_variable_set(:@scoring_fields_cache, nil)

      call_count = 0
      allow(JudgeQuestions).to receive(:new).and_wrap_original do |method, **args|
        judge_questions = method.call(**args)
        allow(judge_questions).to receive(:call).and_wrap_original do |inner_method|
          call_count += 1
          inner_method.call
        end
        judge_questions
      end

      assets.each { |score| score.total }

      unique_divisions = assets.map(&:team_division_name).uniq.size
      expect(call_count).to eq(unique_divisions)
    ensure
      SeasonToggles.clear_judging_round
      SubmissionScore.instance_variable_set(:@scoring_fields_cache, nil)
    end
  end

  describe "CSV export" do
    it "includes total, official, and country columns" do
      grid = described_class.new(
        round: "quarterfinals",
        season: Season.current.year
      )

      header = grid.to_csv.lines.first

      expect(header).to include("Total")
      expect(header).to include("Official")
      expect(header).to include("Country")
    end
  end
end
