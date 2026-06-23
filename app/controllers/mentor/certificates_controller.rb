module Mentor
  class CertificatesController < MentorController

    def index
      @current_certificates = current_account.current_appreciation_certificates
      @previous_certificates = current_account.certificates.mentor_types.previous_certificates
    end
  end
end