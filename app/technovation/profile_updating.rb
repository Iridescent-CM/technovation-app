class ProfileUpdating
  private
  attr_reader :profile, :account, :scope

  public
  def initialize(profile, scope = nil)
    @profile = profile
    @account = profile.account
    @scope = (scope || account.scope_name).to_s.sub(/^\w+_r/, "r")
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
    Geocoding.perform(account)

    send("perform_#{scope}_updates")

    profile.save
    account.save
    account.create_activity(key: "account.update")
  end

  private
  def perform_mentor_updates
  end

  def perform_judge_updates
  end

  def perform_regional_ambassador_updates
    if account.timezone.blank? && account.valid_coordinates?
      timezone_name = Timezone.lookup(*account.coordinates).name
      account.update_column(:timezone, timezone_name)
    end
  end

  def perform_student_updates
    team = profile.team

    if account.saved_change_to_date_of_birth?
      Casting.delegating(account => DivisionChooser) do
        account.reconsider_division_with_save
      end

      if team.present?
        Casting.delegating(team => DivisionChooser) do
          team.reconsider_division_with_save
        end
      end
    end
  end

  def perform_avatar_changes_updates
    if account.saved_change_to_profile_image?
      account.update_column(:icon_path, nil)
    elsif account.saved_change_to_icon_path?
      account.update_column(:profile_image, nil)
    end
  end

  def perform_email_changes_updates
    Casting.delegating(account => EmailUpdater) do
      # TODO: order of operations dependency
      account.update_email_list_profile(scope)

      if account.admin_making_changes
        account.confirm_changed_email!
      else
        account.unconfirm_changed_email!
      end

      if account.saved_change_to_email? and account.signup_attempt
        account.signup_attempt.update_column(:email, account.email)
      end
    end
  end

  module EmailUpdater
    def update_email_list_profile(scope)
      if email_list_changes_made?
        UpdateProfileOnEmailListJob.perform_later(
          id,
          email_before_last_save,
          scope.sub(/^\w+_regional/, "regional").upcase
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
