class UserContext
  attr_reader :user, :referer

  def initialize(user, referer)
    @user = user
    @referer = referer
  end

  def method_missing(method_name, *args, &block)
    user.public_send(method_name, *args, &block)
  end
end
