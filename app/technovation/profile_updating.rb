class ProfileUpdating
  private
  attr_reader :profile, :scope

  public
  def initialize(profile, scope = nil)
    @profile = profile
    @scope = scope || profile.account.scope_name
  end

  def self.execute(profile, scope = nil, attrs)
    new(profile, scope).update(attrs)
  end

  def update(attributes)
    if profile.update(attributes)
      perform_callbacks
      true
    else
      false
    end
  end

  def perform_callbacks
    perform_email_changes_updates
    Geocoding.perform(profile.account)

    case scope.to_sym
    when :student
      perform_student_updates
    end

    profile.save
    profile.account.save
  end

  private
  def perform_student_updates
    team = profile.team

    if team.present? and profile.account.saved_change_to_date_of_birth?
      Casting.delegating(team => DivisionChooser) do
        team.reconsider_division_with_save
      end
    end
  end

  def perform_email_changes_updates
    Casting.delegating(profile.account => EmailUpdater) do
      profile.account.update_email_list_profile(scope)
      profile.account.uncomfirm_changed_email!
    end
  end

  module EmailUpdater
    def update_email_list_profile(scope)
      if email_list_changes_made?
        UpdateProfileOnEmailListJob.perform_later(
          id, email_before_last_save, "#{scope.upcase}_LIST_ID"
        )
      end
    end

    def uncomfirm_changed_email!
      if saved_change_to_email?
        update(email_confirmed_at: nil)
        create_unconfirmed_email_address!(email: email)
        AccountMailer.confirm_changed_email(id).deliver_later
      end
    end

    private
    def email_list_changes_made?
      saved_change_to_city? or
        saved_change_to_state_province? or
          saved_change_to_country? or

      saved_change_to_first_name? or
        saved_change_to_last_name? or

      saved_change_to_email?
    end
  end
end
