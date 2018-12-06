module ImportantDates
  def self.mentor_training_required_since
    year = Integer(ENV.fetch("DATES_MENTOR_TRAINING_YEAR"))
    month = Integer(ENV.fetch("DATES_MENTOR_TRAINING_MONTH"))
    day = Integer(ENV.fetch("DATES_MENTOR_TRAINING_DAY"))
    Time.zone.local(year, month, day)
  end

  def self.registration_opens
    year = Integer(ENV.fetch("DATES_REGISTRATION_OPENS_YEAR"))
    month = Integer(ENV.fetch("DATES_REGISTRATION_OPENS_MONTH"))
    day = Integer(ENV.fetch("DATES_REGISTRATION_OPENS_DAY"))
    Time.zone.local(year, month, day)
  end

  def self.quarterfinals_judging_begins
    year = Integer(ENV.fetch("DATES_QUARTERFINALS_BEGINS_YEAR"))
    month = Integer(ENV.fetch("DATES_QUARTERFINALS_BEGINS_MONTH"))
    day = Integer(ENV.fetch("DATES_QUARTERFINALS_BEGINS_DAY"))
    Time.zone.local(year, month, day)
  end
end