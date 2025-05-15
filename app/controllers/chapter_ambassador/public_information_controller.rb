module ChapterAmbassador
  class PublicInformationController < ChapterAmbassadorController
    skip_before_action :require_chapterable_and_ambassador_onboarded

    layout "chapter_ambassador_rebrand"

    def edit
      current_chapter.chapter_links.build
    end

    def update
      @chapter = current_ambassador.chapter
      if @chapter.update(public_information_params)
        redirect_to chapter_ambassador_public_information_path,
          success: "You updated your chapter public information!"
      else
        flash.now[:alert] = "Error updating chapter details."
        render :edit
      end
    end

    private

    def public_information_params
      params.require(:chapter).permit(
        :name,
        :summary,
        :primary_account_id,
        :visible_on_map,
        chapter_links_attributes: [
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
