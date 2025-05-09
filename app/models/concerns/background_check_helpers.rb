module BackgroundCheckHelpers
  extend ActiveSupport::Concern

  def requires_background_check?
    !background_check_exempt? && (in_background_check_country? && !background_check_complete?)
  end

  def background_check_exempt?
    account.background_check_exemption?
  end

  def in_background_check_country?
    true
  end

  def background_check_complete?
    background_check.present? && background_check.clear?
  end

  def background_check_exempt_or_complete?
    background_check_exempt? || background_check_complete?
  end
end
