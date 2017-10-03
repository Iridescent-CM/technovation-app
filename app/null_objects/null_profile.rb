class NullProfile
  def authenticated?; false; end
  def present?; false; end
  def onboarded?; false; end
  def email; nil; end
  def is_an_ambassador?; false; end
  def past_teams; Team.none; end
end
