class SelectSurvey

  def initialize(user, submissions)
    @user = user
    @period = submissions.has_opened? ? :post : :pre
  end

  def link
    Survey.new(@user, @period).link
  end
end


class Survey
  def initialize(user, period)
    @user = user
    @period = period
  end

  def link
    if @period == :pre
      case @user.role
      when :student
        "https://www.surveymonkey.com/s/683JH6K"
      when :mentor
        "https://www.surveymonkey.com/s/6GLCHTB"
      when :coach
        "https://www.surveymonkey.com/s/SV2FST7"
      end
    elsif @period == :post
      case @user.role
      when :student
        "http://rockman.co1.qualtrics.com/SE/?SID=SV_0cankgvZeqVcy3P"
      when :mentor
        "http://rockman.co1.qualtrics.com/SE/?SID=SV_bjRy3xD4O81l6i9"
      when :coach
        "http://rockman.co1.qualtrics.com/SE/?SID=SV_cN166tnJClpa7jf"
      end
    else
      ""
    end
  end
end
