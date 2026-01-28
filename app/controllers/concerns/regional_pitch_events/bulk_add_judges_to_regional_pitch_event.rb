module RegionalPitchEvents::BulkAddJudgesToRegionalPitchEvent
  def bulk_add_judges
    @event = RegionalPitchEvent
      .current
      .in_region(current_ambassador)
      .find(params[:event_id])

    begin
      SmarterCSV.process(params[:csv_file], {
        chunk_size: 200,
        required_keys: [:judge_id]
      }) do |chunk|
        judge_ids =
          chunk.map do |row|
            row[:judge_id] if row[:judge_id].present?
          end.compact

        AssignJudgesToRegionalPitchEventJob.perform_later(
          regional_pitch_event_id: @event.id,
          account_id: current_account.id,
          judge_ids:
        )
      end

      redirect_to chapter_ambassador_event_path(@event), success: "Your CSV file was uploaded successfully! It will be processed soon!"
    rescue SmarterCSV::MissingKeys
      redirect_to chapter_ambassador_event_path(@event), error: 'Please ensure your CSV file contains a "Judge Id" header.'
    end
  end
end
