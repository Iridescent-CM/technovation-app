module ImportantDates
  def self.new_season_switch
    year = Time.current.year
    month = Integer(ENV.fetch("DATES_NEW_SEASON_START_MONTH"))
    day = Integer(ENV.fetch("DATES_NEW_SEASON_START_DAY"))
    Time.zone.local(year, month, day)
  end

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

  def self.live_quarterfinals_judging_ends
    year = Integer(ENV.fetch("DATES_LIVE_QUARTERFINALS_ENDS_YEAR"))
    month = Integer(ENV.fetch("DATES_LIVE_QUARTERFINALS_ENDS_MONTH"))
    day = Integer(ENV.fetch("DATES_LIVE_QUARTERFINALS_ENDS_DAY"))
    Time.zone.local(year, month, day)
  end

  def self.virtual_quarterfinals_judging_ends
    year = Integer(ENV.fetch("DATES_VIRTUAL_QUARTERFINALS_ENDS_YEAR"))
    month = Integer(ENV.fetch("DATES_VIRTUAL_QUARTERFINALS_ENDS_MONTH"))
    day = Integer(ENV.fetch("DATES_VIRTUAL_QUARTERFINALS_ENDS_DAY"))
    Time.zone.local(year, month, day)
  end

  def self.semifinals_judging_begins
    year = Integer(ENV.fetch("DATES_SEMIFINALS_BEGINS_YEAR"))
    month = Integer(ENV.fetch("DATES_SEMIFINALS_BEGINS_MONTH"))
    day = Integer(ENV.fetch("DATES_SEMIFINALS_BEGINS_DAY"))
    Time.zone.local(year, month, day)
  end

  def self.semifinals_judging_ends
    year = Integer(ENV.fetch("DATES_SEMIFINALS_ENDS_YEAR"))
    month = Integer(ENV.fetch("DATES_SEMIFINALS_ENDS_MONTH"))
    day = Integer(ENV.fetch("DATES_SEMIFINALS_ENDS_DAY"))
    Time.zone.local(year, month, day)
  end

  def self.certificates_available
    year = Integer(ENV.fetch("DATES_CERTIFICATES_AVAILABLE_YEAR"))
    month = Integer(ENV.fetch("DATES_CERTIFICATES_AVAILABLE_MONTH"))
    day = Integer(ENV.fetch("DATES_CERTIFICATES_AVAILABLE_DAY"))
    Time.zone.local(year, month, day)
  end
end