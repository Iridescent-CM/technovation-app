class VisibleScores
  include Enumerable

  def initialize(team_or_teams, options = {})
    @setting = options.fetch(:setting) { Setting }
    @scores = initialize_scores(team_or_teams)
  end

  def each(&block)
    @scores.each { |score| block.call(score) }
  end

  def empty?
    @scores.empty?
  end

  private
  def initialize_scores(team_or_teams)
    Array(team_or_teams).compact.flat_map do |team|
      visible_rubrics(team)
    end
  end

  def visible_rubrics(team)
    @setting.scoresVisible.flat_map do |stage|
      team.public_send("#{stage}_rubrics")
    end
  end
end
