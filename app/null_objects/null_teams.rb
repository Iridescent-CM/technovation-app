class NullTeams < NullObject
  def current
    ::Team.none
  end
end
