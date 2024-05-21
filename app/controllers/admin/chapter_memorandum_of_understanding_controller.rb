module Admin
  class ChapterMemorandumOfUnderstandingController < AdminController
    def create
      @chapter = Chapter.find(params[:chapter_id])

      SendMemorandumOfUnderstandingJob.perform_later(chapter_id: @chapter.id)

      redirect_to admin_chapter_path(@chapter),
        success: "Successfully scheduled job to send MOU to #{@chapter.legal_contact.full_name}"
    end
  end
end
