module BackgroundCheckHelpers
  extend ActiveSupport::Concern

  included do
    delegate :submitted?,
      :candidate_id,
      :report_id,
      :invitation_id,
      to: :background_check,
      prefix: true,
      allow_nil: true
  end

  def requires_background_check?
    in_background_check_country? && !background_check_exempt?
  end

  def background_check_exempt?
    !in_background_check_country? || account.background_check_exemption?
  end

  def background_check_exempt_or_complete?
    background_check_exempt? || background_check_complete?
  end

  def background_check_complete?
    return true if !requires_background_check?

    background_check.present? && background_check.clear?
  end

  def in_background_check_country?
    true
  end
end
