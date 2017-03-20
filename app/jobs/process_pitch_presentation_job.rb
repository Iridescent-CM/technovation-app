class ProcessPitchPresentationJob < ActiveJob::Base
  queue_as :default

  def perform(submission_id, key)
    submission = TeamSubmission.find(submission_id)
    url = "http://s3.amazonaws.com/#{ENV.fetch("AWS_BUCKET_NAME")}/#{key}"
    pitch_presentation = submission.pitch_presentation ||
                           submission.create_pitch_presentation!
    pitch_presentation.update_attributes({
      file_uploaded: true,
      remote_uploaded_file_url: url,
    })
  end
end
