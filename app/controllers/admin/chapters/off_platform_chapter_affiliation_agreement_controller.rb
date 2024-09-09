module Admin::Chapters
  class OffPlatformChapterAffiliationAgreementController < AdminController
    def create
      @chapter = Chapter.find(params[:chapter_id])

      if @chapter.affiliation_agreement.present?
        redirect_to admin_chapter_path(@chapter),
          error: "This chapter already has an active affiliation agreement."
      else
        @chapter.legal_contact.documents.create(
          full_name: @chapter.legal_contact.full_name,
          email_address: @chapter.legal_contact.email_address,
          active: true,
          season_signed: Season.current.year,
          season_expires: Season.current.year + params[:seasons_valid].to_i - 1,
          status: "off-platform"
        )

        redirect_to admin_chapter_path(@chapter),
          success: "Successfully created an off-platform legal agreement this chapter"
      end
    end
  end
end
