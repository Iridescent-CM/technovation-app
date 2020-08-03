module Admin
  class ChapterAmbassadorStatusController < AdminController
    def update
      @chapter_ambassador_profile = ChapterAmbassadorProfile.find(params[:id])
      @chapter_ambassador_profile.update(chapter_ambassador_status_params)
      redirect_to admin_participant_path(@chapter_ambassador_profile.account),
        success: "You set this Chapter Ambassador to #{@chapter_ambassador_profile.status}"
    end

    private
    def chapter_ambassador_status_params
      params.require(:chapter_ambassador_profile).permit(:status)
    end
  end
end
