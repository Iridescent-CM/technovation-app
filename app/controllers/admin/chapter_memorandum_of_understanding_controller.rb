module Admin
  class ChapterMemorandumOfUnderstandingController < AdminController
    def create
      @chapter = Chapter.find(params[:chapter_id])

      SendMemorandumOfUnderstandingJob.perform_later(
        full_name: @chapter.legal_contact_full_name,
        email_address: @chapter.legal_contact_email_address,
        organization_name: @chapter.organization_name,
        job_title: @chapter.legal_contact_job_title
      )

      redirect_to admin_chapter_path(@chapter),
        success: "Successfully scheduled job to send MOU to #{@chapter.legal_contact.full_name}"
    end
  end
end
