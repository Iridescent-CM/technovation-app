module ChapterAmbassador
  class ChapterOrganizationHeadquartersLocationsController < ChapterAmbassadorController
    skip_before_action :require_chapterable_and_ambassador_onboarded

    layout "chapter_ambassador_rebrand"

    def update
      @chapter = current_ambassador.chapter
      if @chapter.update(chapter_organization_headquarters_location_params)
        redirect_to chapter_ambassador_chapter_location_path,
          success: "You updated your chapter organization headquarters location details!"
      else
        flash.now[:alert] = "Error updating chapter organization headquarters location details."
        render :edit
      end
    end

    private

    def chapter_organization_headquarters_location_params
      params.require(:chapter).permit(
        :organization_headquarters_location
      )
    end
  end
end
