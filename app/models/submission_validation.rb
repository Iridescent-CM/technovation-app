module SubmissionValidation
  def self.invalidate(submission)
    Submissions::RequiredFields.new(submission).each(&:invalidate!)
    submission.save!
  end
end
