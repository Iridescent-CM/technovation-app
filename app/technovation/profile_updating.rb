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
    perform_avatar_changes_updates
    Geocoding.perform(profile.account)

    send("perform_#{scope}_updates")

    profile.save
    profile.account.save
  end

  private
  def perform_mentor_updates
  end

  def perform_judge_updates
  end

  def perform_regional_ambassador_updates
  end

  def perform_student_updates
    team = profile.team

    if profile.account.saved_change_to_date_of_birth?
      Casting.delegating(profile.account => DivisionChooser) do
        profile.account.reconsider_division_with_save
      end

      if team.present?
        Casting.delegating(team => DivisionChooser) do
          team.reconsider_division_with_save
        end
      end
    end
  end

  def perform_avatar_changes_updates
    if profile.account.saved_change_to_profile_image?
      profile.account.update_column(:icon_path, nil)
    elsif profile.account.saved_change_to_icon_path?
      profile.account.update_column(:profile_image, nil)
    end
  end

  def perform_email_changes_updates
    Casting.delegating(profile.account => EmailUpdater) do
      # TODO: order of operations dependency
      profile.account.update_email_list_profile(scope)

      if profile.admin_making_changes
        profile.account.confirm_changed_email!
      else
        profile.account.unconfirm_changed_email!
      end
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

    def unconfirm_changed_email!
      if saved_change_to_email?
        update(email_confirmed_at: nil)
        create_unconfirmed_email_address!(email: email)
        AccountMailer.confirm_changed_email(id).deliver_later
      end
    end

    def confirm_changed_email!
      if saved_change_to_email?
        email_confirmed!
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
