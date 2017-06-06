module CheckIfCertificateIsAllowed
  class << self
    def call(user, cert_type)
      return false if user.blank?

      case String(cert_type)
      when "completion"
        completion_allowed?(user)
      when "appreciation"
        appreciation_allowed?(user)
      when "rpe_winner"
        rpe_winner_allowed?(user)
      else
        false
      end
    end

    private
    def completion_allowed?(user)
      user.student_profile.present? and user.team.submission.present?
    end

    def appreciation_allowed?(user)
      user.mentor_profile.present? and user.is_on_team?
    end

    def rpe_winner_allowed?(user)
      if user.mentor_profile.present?
        false
=begin
        user.is_on_team? and
          user.teams.any? do |team|
            team.submission.present? and
              team.selected_regional_pitch_event.live? and
                not team.selected_regional_pitch_event.unofficial? and
                  team.submission.semifinalist?
          end
=end
      elsif user.student_profile.present?
        user.is_on_team? and
          user.team.submission.present? and
            user.team.selected_regional_pitch_event.live? and
              not user.team.selected_regional_pitch_event.unofficial? and
                user.team.submission.semifinalist?
      else
        false
      end
    end
  end
end
