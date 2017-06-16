class ProfileUpdating
  private
  attr_reader :profile, :scope

  public
  def initialize(profile, scope = nil)
    @profile = profile
    @scope = scope || profile.account.type_name
  end

  def self.execute(profile, scope = nil, attrs)
    new(profile, scope).update(attrs)
  end

  def update(attributes)
    if profile.update_attributes(attributes)
      perform_callbacks
      true
    else
      false
    end
  end

  def perform_callbacks
    perform_email_changes_callbacks

    case scope.to_sym
    when :student
      perform_student_callbacks
    end
  end

  private
  def perform_student_callbacks
    Casting.delegating(profile => TeamDivisionChooser) do
      profile.reconsider_team_division
    end
  end

  def perform_email_changes_callbacks
    Casting.delegating(profile.account => EmailListUpdater) do
      profile.account.update_email_list_profile(scope)
    end
  end

  module EmailListUpdater
    def update_email_list_profile(scope)
      if saved_change_to_first_name? or saved_change_to_last_name? or
          saved_change_to_email? or address_changed?
        UpdateProfileOnEmailListJob.perform_later(
          id, email_before_last_save, "#{scope.upcase}_LIST_ID"
        )
      end
    end
  end

  module TeamDivisionChooser
    def reconsider_team_division
      if team.present? and saved_change_to_date_of_birth?
        team.update_attributes({
          division_id: Division.for(team).id,
        })
      end
    end
  end
end
