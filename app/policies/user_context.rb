class UserContext
  attr_reader :user, :referer

  def initialize(user, referer)
    @user = user
    @referer = referer
  end
end
