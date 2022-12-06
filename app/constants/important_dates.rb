module ImportantDates
  def self.division_cutoff
    year = Integer(ENV.fetch("DATES_DIVISION_CUTOFF_YEAR"))
    month = Integer(ENV.fetch("DATES_DIVISION_CUTOFF_MONTH"))
    day = Integer(ENV.fetch("DATES_DIVISION_CUTOFF_DAY"))
    Time.zone.local(year, month, day)
  end

  def self.new_season_switch
    year = Time.current.year
    month = Integer(ENV.fetch("DATES_NEW_SEASON_START_MONTH"))
    day = Integer(ENV.fetch("DATES_NEW_SEASON_START_DAY"))
    Time.zone.local(year, month, day)
  end

  def self.official_start_of_season
    year = Integer(ENV.fetch("DATES_OFFICIAL_START_OF_SEASON_YEAR"))
    month = Integer(ENV.fetch("DATES_OFFICIAL_START_OF_SEASON_MONTH"))
    day = Integer(ENV.fetch("DATES_OFFICIAL_START_OF_SEASON_DAY"))
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

  def self.team_registration_deadline
    year = Integer(ENV.fetch("DATES_TEAM_REGISTRATION_DEADLINE_YEAR"))
    month = Integer(ENV.fetch("DATES_TEAM_REGISTRATION_DEADLINE_MONTH"))
    day = Integer(ENV.fetch("DATES_TEAM_REGISTRATION_DEADLINE_DAY"))
    Time.zone.local(year, month, day)
  end

  def self.rpe_officiality_finalized
    year = Integer(ENV.fetch("DATES_RPE_OFFICIALITY_FINALIZED_YEAR"))
    month = Integer(ENV.fetch("DATES_RPE_OFFICIALITY_FINALIZED_MONTH"))
    day = Integer(ENV.fetch("DATES_RPE_OFFICIALITY_FINALIZED_DAY"))
    Time.find_zone(Rails.configuration.time_zone).local(year, month, day, 23, 59)
  end

  def self.submission_deadline
    year = Integer(ENV.fetch("DATES_SUBMISSION_DEADLINE_YEAR"))
    month = Integer(ENV.fetch("DATES_SUBMISSION_DEADLINE_MONTH"))
    day = Integer(ENV.fetch("DATES_SUBMISSION_DEADLINE_DAY"))
    hour = Integer(ENV.fetch("DATES_SUBMISSION_DEADLINE_HOUR_IN_24_HOUR_FORMAT", 17))

    Time.zone.local(year, month, day, hour)
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
