class ProfileCreating
  private
  attr_reader :profile, :scope, :controller

  public
  def initialize(profile, controller, scope = nil)
    @profile = profile
    @scope = scope || profile.account.scope_name
    @controller = controller
  end

  def self.execute(*args)
    new(*args).execute
  end

  def execute
    profile.account.email_confirmed!
    controller.remove_cookie(:signup_token)
    AttachSignupAttemptJob.perform_later(profile.account)

    case scope.to_sym
    when :student
      TeamMemberInvite.match_registrant(profile)
    when :regional_ambassador
      AdminMailer.pending_regional_ambassador(profile.account).deliver_later
    end

    SignIn.(
      profile.account,
      controller,
      redirect_to: "#{scope}_dashboard_path"
    )
  end
end
