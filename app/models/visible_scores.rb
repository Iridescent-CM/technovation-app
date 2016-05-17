class VisibleScores
  TeamScore = Struct.new(:team, :rubrics)

  include Enumerable

  def initialize(teams, setting = Setting)
    @teams = [teams].flatten
    @setting = setting
  end

  def each(&block)
    @teams.each do |team|
      block.call(TeamScore.new(team.name, visible_rubrics(team)))
    end
  end

  private
  def visible_rubrics(team)
    @setting.scoresVisible.flat_map do |stage|
      team.public_send("#{stage}_rubrics")
    end
  end
end
