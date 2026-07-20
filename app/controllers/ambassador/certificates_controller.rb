module Ambassador
  class CertificatesController < AmbassadorController
    skip_before_action :require_chapterable_and_ambassador_onboarded

    layout :set_layout_for_current_ambassador

    def index
      @current_certificates = current_account.current_ambassador_appreciation_certificates
      @current_letter = current_account.current_ambassador_letter_certificates.last
    end
  end
end
