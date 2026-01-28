module RegionalPitchEvents::BulkAddTeamsToRegionalPitchEvent
  def bulk_add_teams
    @event = RegionalPitchEvent
      .current
      .in_region(current_ambassador)
      .find(params[:event_id])

    begin
      SmarterCSV.process(params[:csv_file], {
        chunk_size: 200,
        required_keys: [:team_id]
      }) do |chunk|
        team_ids =
          chunk.map do |row|
            row[:team_id] if row[:team_id].present?
          end.compact

        AssignTeamsToRegionalPitchEventJob.perform_later(
          regional_pitch_event_id: @event.id,
          account_id: current_account.id,
          team_ids:
        )
      end

      redirect_to chapter_ambassador_event_path(@event), success: "Your CSV file was uploaded successfully! It will be processed soon!"
    rescue SmarterCSV::MissingKeys
      redirect_to chapter_ambassador_event_path(@event), error: 'Please ensure your CSV file contains a "Team Id" header.'
    end
  end
end
