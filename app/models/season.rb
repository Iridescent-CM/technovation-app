class Season
  START_MONTH = ImportantDates.new_season_switch.month
  START_DAY = ImportantDates.new_season_switch.day

  attr_accessor :year

  def initialize(year)
    @year = year
  end

  def self.submission_deadline
    [
      submission_deadline_in_los_angeles_time_zone,
      submission_deadline_in_africa_time_zone,
      submission_deadline_in_madrid_time_zone,
      submission_deadline_in_india_time_zone
    ].join(" / ").squish
  end

  def self.years
    (2015..Season.current.year).to_a
  end

  def self.current
    new(current_season_year)
  end

  def self.next
    nxt = current
    nxt.year += 1
    nxt
  end

  def self.for(record)
    if record.created_at < switch_date(record.created_at.year)
      new(record.created_at.year)
    else
      new(record.created_at.year + 1)
    end
  end

  def self.switch_date(year = Time.current.year)
    Date.new(year, START_MONTH, START_DAY)
  end

  private
  def self.current_season_year
    current_year = Time.current.year

    if Date.current >= switch_date
      current_year += 1
    end

    current_year
  end

  def self.submission_deadline_in_los_angeles_time_zone
    ImportantDates.submission_deadline.in_time_zone("America/Los_Angeles").strftime("%B %d, %l%p PDT")
  end

  def self.submission_deadline_in_africa_time_zone
    ImportantDates.submission_deadline.in_time_zone("Africa/Algiers").strftime("%B %d at %l%p WAT")
  end

  def self.submission_deadline_in_madrid_time_zone
    ImportantDates.submission_deadline.in_time_zone("Europe/Madrid").strftime("%l%p CEST")
  end

  def self.submission_deadline_in_india_time_zone
    ImportantDates.submission_deadline.in_time_zone("Asia/Kolkata").strftime("%l%p IST")
  end

  private_class_method :submission_deadline_in_los_angeles_time_zone,
    :submission_deadline_in_africa_time_zone,
    :submission_deadline_in_madrid_time_zone,
    :submission_deadline_in_india_time_zone
end
