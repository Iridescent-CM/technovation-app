module Mentor
  class CertificatesController < MentorController

    def index
      @current_certificates = current_account.current_appreciation_certificates
    end
  end
end