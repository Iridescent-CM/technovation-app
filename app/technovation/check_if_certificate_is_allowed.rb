module CheckIfCertificateIsAllowed
  class << self
    def call(user, cert_type)
      return false if user.blank?

      if user.student_profile.present?
        user.team.submission.present?
      elsif user.mentor_profile.present?
        user.is_on_team?
      else
        false
      end
    end
  end
end
