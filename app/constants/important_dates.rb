module ImportantDates
  def self.mentor_training_required_since
    year = Integer(ENV.fetch("DATES_MENTOR_TRAINING_YEAR"))
    month = Integer(ENV.fetch("DATES_MENTOR_TRAINING_MONTH"))
    day = Integer(ENV.fetch("DATES_MENTOR_TRAINING_DAY"))
    Date.new(year, month, day)
  end

  def self.registration_opens
    year = Integer(ENV.fetch("DATES_REGISTRATION_OPENS_YEAR"))
    month = Integer(ENV.fetch("DATES_REGISTRATION_OPENS_MONTH"))
    day = Integer(ENV.fetch("DATES_REGISTRATION_OPENS_DAY"))
    Date.new(year, month, day)
  end
end