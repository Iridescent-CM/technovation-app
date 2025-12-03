module BulkAddTeamsToRegionalPitchEvent
  def bulk_add_teams
    @event = RegionalPitchEvent
      .current
      .in_region(current_ambassador)
      .find(params[:event_id])

    begin
      SmarterCSV.process(params[:csv_file], {
        chunk_size: 100,
        required_keys: [:team_id]
      }) do |chunk|
        team_ids =
          chunk.map do |row|
            row[:team_id] if row[:team_id].present?
          end.compact

        AssignTeamsToRegionalPitchEventJob.perform_now(regional_pitch_event_id: @event.id, team_ids:)

        render "admin/regional_pitch_events/show"
      end
    rescue SmarterCSV::MissingKeys
      redirect_to chapter_ambassador_event_path(@event), error: 'Please ensure the CSV contains a "Team Id" header.'
    end
  end
end
