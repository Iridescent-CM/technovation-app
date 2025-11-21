module BulkAddTeamsToRegionalPitchEvent
  def bulk_add_teams
    @event = RegionalPitchEvent
      .includes(
        judges: :current_account,
        teams: [
          :division,
          submission: [:team, :screenshots]
        ]
      )
      .find(params[:event_id])
    SmarterCSV.process(params[:csv_file], {chunk_size: 100}) do |chunk|
      team_ids = chunk.map do |row|
        row[:team_id] if row[:team_id].present?
      end.compact

      result = DataProcessors::AssignTeamsToRegionalPitchEvent.new(team_ids:, rpe_id: @event.id).call

      flash.now[:alert] = result.results
      render "admin/regional_pitch_events/show"
    end
  end
end
