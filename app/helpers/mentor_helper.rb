module MentorHelper
  def filter_by(sym)
    url_params = {:action => :index}
    User::EXPERTISES.each do |e|
      url_params[e[:sym]] = (sym == e[:sym])
    end
    url_for(url_params)
  end
end
