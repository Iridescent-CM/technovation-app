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
    icon_path = case scope.to_sym
                when :regional_ambassador
                  ""
                else
                  ActionController::Base.helpers.asset_path(
                    "placeholders/avatars/#{rand(1..24)}.svg"
                  )
                end

    profile.account.update({
      email_confirmed_at: Time.current,
      icon_path: icon_path,
      division: Division.for(profile.account),
    })

    controller.remove_cookie(:signup_token)

    AttachSignupAttemptJob.perform_later(profile.account)

    case scope.to_sym
    when :student
      TeamMemberInvite.match_registrant(profile)
    when :regional_ambassador
      AdminMailer.pending_regional_ambassador(profile.account).deliver_later
    when :mentor
      RegistrationMailer.welcome_mentor(profile.account_id).deliver_later
    end

    SignIn.(
      profile.account,
      controller,
      message: "Welcome to Technovation!",
      redirect_to: "#{scope}_dashboard_path",
    )
  end
end
