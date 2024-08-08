module Admin
  class ChapterAffiliationAgreementController < AdminController
    def create
      @chapter = Chapter.find(params[:chapter_id])

      SendChapterAffiliationAgreementJob.perform_later(chapter_id: @chapter.id)

      redirect_to admin_chapter_path(@chapter),
        success: "Successfully scheduled job to send a Chapter Affiliation Agreement to #{@chapter.legal_contact.full_name}"
    end

    def void
      chapter = Chapter.find(params[:chapter_id])

      VoidDocumentJob.perform_later(document_id: chapter.affiliation_agreement.id)

      redirect_to admin_chapter_path(chapter),
        success: "Successfully scheduled job to void the Chapter Affiliation Agreement for #{chapter.legal_contact.full_name}"
    end
  end
end
