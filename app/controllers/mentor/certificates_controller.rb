module Mentor
  class CertificatesController < MentorController

    def index
      @current_certificates = current_account.current_appreciation_certificates.preload(:team)
      @previous_certificates = current_account.certificates.mentor_types.previous_certificates.preload(:team)
    end
  end
end
