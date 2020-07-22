class ProfileCreating
  private
  attr_reader :profile, :scope, :controller

  public
  def initialize(profile, controller, scope = nil)
    @profile = profile
    @scope = (scope || profile.account.scope_name)
               .to_s.sub(/^\w+_chapter_ambassador/, "chapter_ambassador")
    @controller = controller
  end

  def self.execute(*args)
    new(*args).execute
  end

  def execute
    icon_path = case scope.to_sym
                when :chapter_ambassador
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

    controller.remove_cookie(CookieNames::SIGNUP_TOKEN)

    AttachSignupAttemptJob.perform_later(profile.account_id)
    AttachUserInvitationJob.perform_later(profile.account_id)

    case scope.to_sym
    when :student
      if profile.reload.parental_consent.nil?
        profile.parental_consents.create! # pending by default
      end
      TeamMemberInvite.match_registrant(profile)
    when :mentor
      RegistrationMailer.welcome_mentor(profile.account_id).deliver_later
    end

    Geocoding.perform(profile.account).with_save

    profile.account.create_activity(
      key: "account.create"
    )

    SignIn.(
      profile.account,
      controller,
      message: "Welcome to Technovation!",
      redirect_to: "#{scope}_dashboard_path",
    )
  end
end
