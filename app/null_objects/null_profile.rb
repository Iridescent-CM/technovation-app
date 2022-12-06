require "./app/null_objects/null_object"
require "./app/null_objects/null_account"

class NullProfile < NullObject
  def id; nil; end
  def authenticated?; false; end
  def onboarded?; false; end
  def email; false; end
  def is_an_ambassador?; false; end
  def past_teams; ::Team.none; end
  def mailer_token; false; end
  def current_completed_scores; []; end
  def completed_scores; NullCompletedScores.new; end
  def events; []; end
  def account; ::NullAccount.new; end
  def rebranded?; false; end
end

class NullCompletedScores < NullObject
  def by_season(*); []; end
end
