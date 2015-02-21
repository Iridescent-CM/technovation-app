module MentorHelper
  def filter_checked(exp)
    params[exp[:sym]] == 'true'
  end
end
