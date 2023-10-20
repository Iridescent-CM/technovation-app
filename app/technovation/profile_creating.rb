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
    case scope.to_sym
    when :student
      if profile.reload.parental_consent.nil?
        profile.parental_consents.create! # pending by default
      end
      TeamMemberInvite.match_registrant(profile)
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
