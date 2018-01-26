class RequiredFields
  include Enumerable

  attr_reader :submission, :fields

  def initialize(submission)
    @submission = submission
    @fields = [
      RequiredAppNameField.new(submission, :app_name),
      RequiredField.new(submission, :app_description),
      RequiredField.new(submission, :development_platform_text),
      RequiredField.new(submission, :demo_video_link),
      RequiredField.new(submission, :pitch_video_link),
      RequiredField.new(submission, :source_code_url),
      RequiredScreenshotsField.new(submission, :screenshots),
    ]

    if submission.senior_division?
      @fields << RequiredField.new(submission, :business_plan)
    end

    freeze
  end

  def each(&block)
    fields.each(&block)
  end

  alias :size :count
end

class RequiredField
  attr_reader :submission, :method_name

  def self.for(submission, method_name)
    if method_name.to_sym == :app_name
      RequiredAppNameField.new(submission, method_name)
    elsif method_name.to_sym == :screenshots
      RequiredScreenshotsField.new(submission, method_name)
    else
      RequiredField.new(submission, method_name)
    end
  end

  def initialize(submission, method_name)
    @submission = submission
    @method_name = method_name
    freeze
  end

  def complete?
    not submission.send(method_name).blank?
  end
end

class RequiredScreenshotsField < RequiredField
  def complete?
    submission.send(method_name).count >= 2
  end
end

class RequiredAppNameField < RequiredField
  def complete?
    submission.send(method_name) != "(no name yet)"
  end
end
