module BulkDownloadSubmissionPitchPresentations
  include Zipline

  def bulk_download_submission_pitch_presentations
    event = RegionalPitchEvent.find(params[:event_id])
    pitch_presentations = event.team_submissions.with_pitch_presentations.map do |submission|
      [
        submission.pitch_presentation.url,
        "#{submission.team.name}-#{submission.pitch_presentation.file.filename.downcase.gsub(/\s+/, "_")}"
      ]
    end

    zipline(
      pitch_presentations,
      "#{event.name.downcase.parameterize(separator: "_")}_presentation_slides.zip",
      auto_rename_duplicate_filenames: true
    )
  end
end
