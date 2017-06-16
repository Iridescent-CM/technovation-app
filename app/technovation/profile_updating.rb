class ProfileUpdating
  private
  attr_reader :profile

  public
  def initialize(profile)
    @profile = profile
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
    case profile.account.type_name
    when "student"
      perform_student_callbacks
    end
  end

  private
  def perform_student_callbacks
    Casting.delegating(profile => TeamDivisionChooser) do
      profile.reconsider_team_division
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
