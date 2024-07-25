module Admin
  class ChapterMemorandumOfUnderstandingController < AdminController
    def create
      @chapter = Chapter.find(params[:chapter_id])

      SendMemorandumOfUnderstandingJob.perform_later(chapter_id: @chapter.id)

      redirect_to admin_chapter_path(@chapter),
        success: "Successfully scheduled job to send MOU to #{@chapter.legal_contact.full_name}"
    end

    def void
      chapter = Chapter.find(params[:chapter_id])

      VoidDocumentJob.perform_later(document_id: chapter.legal_document.id)

      redirect_to admin_chapter_path(chapter),
        success: "Successfully scheduled job to void MOU"
    end
  end
end
