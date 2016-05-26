class SelectSurvey

  def initialize(user)
    @user = user
  end

  def link
    if !@user.is_registered
      return ""
    else
      Survey.new(@user.role).link
    end
  end
end


class Survey
  def initialize(role)
    @role = role
    @link = link_for(role)
  end

  def link
    @link
  end

  private
    def link_for(role)
      "#{role}_link"
    end
end
