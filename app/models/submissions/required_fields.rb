class RequiredFields
  include Enumerable

  attr_reader :submission, :fields

  def initialize(submission)
    @submission = submission

    @fields = %i[
      app_name
      app_description
      learning_journey
      development_platform_text
      pitch_video_link
      demo_video_link
      screenshots
      source_code_url
    ].map do |field|
      RequiredField.for(submission, field)
    end

    if submission.junior_division? || submission.senior_division?
      @fields << RequiredField.new(submission, :business_plan)
    end

    freeze
  end

  def each(&block)
    fields.each(&block)
  end

  alias_method :size, :count
end

class RequiredField
  attr_reader :submission, :method_name, :value

  def self.for(submission, method_name)
    if method_name.to_sym == :app_name
      RequiredAppNameField.new(submission, method_name)
    elsif method_name.to_sym == :screenshots
      RequiredScreenshotsField.new(submission, method_name)
    elsif method_name.to_sym == :development_platform_text
      RequiredDevPlatformField.new(submission, method_name)
    elsif method_name.to_sym == :source_code_url
      RequiredSourceCodeField.new(submission, method_name)
    else
      RequiredField.new(submission, method_name)
    end
  end

  def initialize(submission, method_name)
    @submission = submission
    @method_name = method_name
    @value = submission.send(method_name)
    freeze
  end

  def invalidate!
    submission.public_send(:"#{method_name}=", nil)
  end

  def complete?
    !blank?
  end

  def blank?
    value.blank?
  end
end

class RequiredScreenshotsField < RequiredField
  def blank?
    value.count < 2
  end

  def invalidate!
    submission.screenshots.destroy_all
  end
end

class RequiredAppNameField < RequiredField
  def blank?
    value.blank? || value == TeamSubmission::DEFAULT_APP_NAME
  end
end

class RequiredDevPlatformField < RequiredField
  def invalidate!
    submission.development_platform = nil
    submission.development_platform_other = nil
    submission.app_inventor_app_name = nil
    submission.app_inventor_gmail = nil
  end
end

class RequiredSourceCodeField < RequiredField
  def invalidate!
    submission.source_code = nil
    submission.source_code_external_url = nil
  end

  def blank?
    if submission.developed_on?("Thunkable")
      submission.source_code_external_url.blank?
    elsif submission.developed_on?("Scratch")
      submission.source_code_external_url.blank? && submission.source_code.blank?
    else
      value.blank?
    end
  end
end
