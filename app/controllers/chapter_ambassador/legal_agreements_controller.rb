module ChapterAmbassador
  class LegalAgreementsController < ChapterAmbassadorController
    def create
      SendChapterAmbassadorLegalAgreementJob.perform_later(
        chapter_ambassador_profile_id: current_ambassador.id
      )

      redirect_to chapter_ambassador_mou_path,
        success: "You should receive an email from DocuSign soon. If you do not receive this email or you are having issues please reach out to #{ENV.fetch("HELP_EMAIL")}"
    end
  end
end
