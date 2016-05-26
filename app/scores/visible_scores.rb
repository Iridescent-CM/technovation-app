class VisibleScores
  TeamScore = Struct.new(:team, :rubrics)

  include Enumerable

  def initialize(teams, setting = Setting)
    @setting = setting
    @teams = initialize_teams(teams)
  end

  def each(&block)
    @teams.each { |team| block.call(team) }
  end

  private
  def initialize_teams(teams)
    [teams].flatten.compact.map do |team|
      TeamScore.new(team.name, visible_rubrics(team))
    end
  end

  def visible_rubrics(team)
    @setting.scoresVisible.flat_map do |stage|
      team.public_send("#{stage}_rubrics")
    end
  end
end
