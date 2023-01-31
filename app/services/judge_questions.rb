class JudgeQuestions
  attr_reader :season, :division

  def initialize(season:, division:)
    @season = season.presence || Season.current.year
    @division = division
  end

  def call
    "Judging::#{season_module_name}::#{questions_class_name}".constantize.new.call
  end

  private

  def season_module_name
    case season
    when 2023
      "TwentyTwentyThree"
    when 2022
      "TwentyTwentyTwo"
    when 2021
      "TwentyTwentyOne"
    when 2020
      "TwentyTwenty"
    else
      if season < 2020
        raise "Questions for the #{season} season don't exist! Most likely the questions could be added by looking at the commit history for `quesitons.rb`."
      else
        raise "Questions for the #{season} season haven't been setup yet! You'll likely want to copy the previous year's queetions in '/app/services/judging/#{season - 1}/' to get them setup."
      end
    end
  end

  def questions_class_name
    case division&.downcase
    when "beginner"
      "BeginnerQuestions"
    when "junior"
      "JuniorQuestions"
    when "senior"
      "SeniorQuestions"
    else
      "SeniorQuestions"
    end
  end
end
