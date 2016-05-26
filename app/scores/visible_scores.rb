class VisibleScores
  TeamScore = Struct.new(:team, :rubrics)

  include Enumerable

  def initialize(teams, options = {})
    @setting = options.fetch(:setting) { Setting }
    @filter = options.fetch(:filter_with) { NoFilter }
    @filter_limit = options.fetch(:filter_limit) { -1 }
    @teams = initialize_teams(teams)
  end

  def each(&block)
    @teams.each { |team| block.call(team) }
  end

  private
  def initialize_teams(teams)
    [teams].flatten.compact.map do |team|
      rubrics = @filter.new(visible_rubrics(team), @filter_limit)
      TeamScore.new(team.name, rubrics)
    end
  end

  def visible_rubrics(team)
    @setting.scoresVisible.flat_map do |stage|
      team.public_send("#{stage}_rubrics")
    end
  end

  class NoFilter
    include Enumerable

    def initialize(scores, *args)
      @scores = scores
    end

    def each(&block)
      @scores.each { |s| block.call(s) }
    end

    def empty?
      @scores.empty?
    end
  end
end
