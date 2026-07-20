module Mentor
  class CertificatesController < MentorController

    def index
      @current_certificates = current_account.current_appreciation_certificates.preload(:team)
      @current_mentor_letter = current_account.current_mentor_letter_certificates.last
      @previous_certificates = current_account.certificates.mentor_types.previous_certificates.preload(:team)
    end
  end
end
