class Season
  attr_accessor :year

  def initialize(year)
    @year = year
  end

  def self.current
    if Date.today < switch_date
      new(Date.today.year)
    else
      new(Date.today.year + 1)
    end
  end

  def self.next
    nxt = current

    unless SeasonToggles.registration_closed? and
             Date.today >= switch_date
      nxt.year += 1
    end

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
end
