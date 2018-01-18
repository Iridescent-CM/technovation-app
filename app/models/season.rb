class Season
  attr_accessor :year

  def initialize(year)
    @year = year
  end

  def self.deadline
    "April 25"
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
    Date.new(year, switch_month, switch_day)
  end

  def self.switch_month
    10
  end

  def self.switch_day
    1
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
