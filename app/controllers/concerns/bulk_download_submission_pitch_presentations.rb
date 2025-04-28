module BulkDownloadSubmissionPitchPresentations
  include Zipline

  def bulk_download_submission_pitch_presentations
    event = RegionalPitchEvent.find(params[:event_id])
    pitch_presentations = event.team_submissions.map do |submission|
      if submission.pitch_presentation.present?
        [
          submission.pitch_presentation.url,
          "#{submission.team.name.downcase.parameterize(separator: "_")}-#{submission.pitch_presentation.file.filename.downcase.parameterize(separator: "_")}"
        ]
      end
    end

    zipline(
      pitch_presentations,
      "#{event.name.downcase.parameterize(separator: "_")}_presentation_slides.zip",
      auto_rename_duplicate_filenames: true
    )
  end
end
