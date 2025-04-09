module Ambassador
  class TeamSubmissionsController < AmbassadorController
    layout "ambassador"

    def show
      @team_submission = if current_ambassador.national_view?
        TeamSubmission.in_region(current_ambassador.chapter)
          .friendly.find(params[:id])
      else
        TeamSubmission.by_chapterable(
          current_ambassador.chapterable_type,
          current_ambassador.current_chapterable.id
        ).friendly.find(params[:id])
      end
    end
  end
end
