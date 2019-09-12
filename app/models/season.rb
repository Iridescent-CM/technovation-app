class Season
  START_MONTH = ImportantDates.new_season_switch.month
  START_DAY = ImportantDates.new_season_switch.day

  attr_accessor :year

  def initialize(year)
    @year = year
  end

  def self.deadline
    "April 23rd"
  end

  def self.submission_deadline
    "#{deadline}, #{current.year}"
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
end
