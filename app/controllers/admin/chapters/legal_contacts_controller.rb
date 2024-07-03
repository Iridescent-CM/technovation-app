module Admin::Chapters
  class LegalContactsController < AdminController
    def create
      @chapter = Chapter.find(params[:chapter_id])
      @legal_contact = @chapter.build_legal_contact(legal_contact_params)

      if @legal_contact.save
        redirect_to admin_chapter_path(@chapter), success: "#{@legal_contact.full_name} was successfully added as a legal contact for this chapter."
      else
        render :new
      end
    end

    def edit
      @chapter = Chapter.find(params[:chapter_id])
      @legal_contact = @chapter.legal_contact
    end

    def update
      @chapter = Chapter.find(params[:chapter_id])
      @legal_contact = @chapter.legal_contact
      @chapter_invite = UserInvitation.new
      @pending_chapter_invites = UserInvitation.pending.where(chapter_id: params[:id])

      if @legal_contact.update(legal_contact_params)
        redirect_to admin_chapter_path(@chapter), success: "Legal contact updated successfully."
      else
        render :edit
      end
    end

    private

    def legal_contact_params
      params.require(:legal_contact).permit(
        :full_name,
        :email_address,
        :phone_number,
        :job_title
      )
    end
  end
end
