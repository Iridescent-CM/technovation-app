class NullJoinRequest
  def present; false; end
  def status; :missing; end
  def requestor; NullProfile.new; end
  def team; NullTeam.new; end
end
