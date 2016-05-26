class SelectSurvey

  def initialize(user, submissions)
    @user = user
    @period = submissions.has_opened? ? :post : :pre
  end

  def link
    if !@user.is_registered
      return ""
    else
      Survey.new(@user).link
    end
  end
end


class Survey
  def initialize(user)
    @user = user
  end

  def link
    case @user.role
    when :student
      "https://www.surveymonkey.com/s/683JH6K"
    when :mentor
      "https://www.surveymonkey.com/s/6GLCHTB"
    when :coach
      "https://www.surveymonkey.com/s/SV2FST7"
    end
  end
end
