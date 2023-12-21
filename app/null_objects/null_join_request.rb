class NullJoinRequest < NullObject
  def status
    :missing
  end

  def missing?
    true
  end

  def requestor
    ::NullProfile.new
  end

  def team
    ::NullTeam.new
  end
end
