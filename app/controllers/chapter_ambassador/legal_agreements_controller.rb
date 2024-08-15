module ChapterAmbassador
  class LegalAgreementsController < ChapterAmbassadorController
    skip_before_action :require_chapter_and_chapter_ambassador_onboarded

    layout "chapter_ambassador_rebrand"

    def create
      if current_ambassador.legal_agreement.present?
        redirect_to chapter_ambassador_legal_agreement_path,
          error: "You should have already received an email from Docusign or should be receiving it soon. If you do not receive this email or you are having issues please reach out to #{ENV.fetch("HELP_EMAIL")}."
      else
        SendChapterAmbassadorLegalAgreementJob.perform_later(
          chapter_ambassador_profile_id: current_ambassador.id
        )

        redirect_to chapter_ambassador_legal_agreement_path(legal_agreement_sent: 1),
          success: "You should receive an email from DocuSign soon. If you do not receive this email or you are having issues please reach out to #{ENV.fetch("HELP_EMAIL")}."
      end
    end
  end
end
