module ChapterAmbassador
  class ChapterLocationsController < ChapterAmbassadorController
    layout "chapter_ambassador_rebrand"

    def update
      @chapter = current_ambassador.chapter
      if @chapter.update(chapter_location_params)
        redirect_to chapter_ambassador_chapter_location_path,
                    success: "You updated your chapter location details!"
      else
        flash.now[:alert] = "Error updating chapter location details."
        render :edit
      end
    end

    private

    def chapter_location_params
      params.require(:chapter).permit(
        :organization_headquarters_location
      )
    end

  end
end
