class VisibleScores
  TeamScore = Struct.new(:team, :rubrics)

  include Enumerable

  def initialize(user, rubric_list = Rubric, setting = Setting)
    @user = user
    @teams = user.teams
    @rubric_list = rubric_list
    @setting = setting
  end

  def each(&block)
    @teams.each do |team|
      block.call(
        TeamScore.new(team.name,
                      team.rubrics.where(stage: visible_stages))
      )
    end
  end

  private
  def visible_stages
    @setting.scoresVisible.map { |s| @rubric_list.stages[s] }
  end
end
