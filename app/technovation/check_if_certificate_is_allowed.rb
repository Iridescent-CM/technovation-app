module CheckIfCertificateIsAllowed
  class << self
    def call(user, cert_type)
      return false if user.blank?

      case user.type_name
      when "student"
        user.team.submission.complete?
      else
        false
      end
    end
  end
end
