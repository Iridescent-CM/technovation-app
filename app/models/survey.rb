class Survey

  def initialize(user)
    @user = user
  end

  def link
    if !@user.is_registered
      return ""
    else
      "oi!"
    end
  end
end
