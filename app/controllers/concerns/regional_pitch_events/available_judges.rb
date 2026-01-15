module RegionalPitchEvents::AvailableJudges
  private

  def load_available_judges_for_event(event)
    judges = if params[:query].present?
      JudgeProfile
        .available_for_events(event, current_ambassador)
        .by_query(params[:query])
    else
      JudgeProfile.available_for_events(event, current_ambassador)
    end

    judges.paginate(page: params[:page], per_page: 20)
  end
end
