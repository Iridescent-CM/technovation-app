module ChapterAmbassador
  class IntroductionsController < ChapterAmbassadorController
    def edit
      current_ambassador.regional_links.build
    end

    def update
      if ProfileUpdating.execute(current_ambassador, nil, introduction_params)
        redirect_to chapter_ambassador_dashboard_path(anchor: "!chapter-ambassador-info"),
          success: "You updated your introduction!"
      else
        render :edit
      end
    end

    private
    def introduction_params
      params.require(:chapter_ambassador_profile).permit(
        :program_name,
        :intro_summary,
        regional_links_attributes: [
          :id,
          :_destroy,
          :name,
          :value,
          :custom_label,
        ],
      )
    end
  end
end
