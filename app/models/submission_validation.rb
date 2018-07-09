module SubmissionValidation
  def self.invalidate(submission)
    RequiredFields.new(submission).each(&:invalidate!)
    submission.save!
  end
end
