module ChapterAmbassador
  class PublicInformationController < ChapterAmbassadorController
    layout "chapter_ambassador_rebrand"

    def update
      @chapter = current_ambassador.chapter
      if @chapter.update(public_information_params)
        redirect_to chapter_ambassador_public_information_path,
                  success: "You updated your chapter public information!"
      else
        flash.now[:alert] = "Error updating chapter details. Please try again later."
        render :edit
      end
    end

    private

    def public_information_params
      params.require(:chapter).permit(
        :name,
        :summary,
        :primary_contact_id,
        regional_links_attributes: [
          :id,
          :_destroy,
          :name,
          :value,
          :custom_label
        ]
      )
    end
  end
end