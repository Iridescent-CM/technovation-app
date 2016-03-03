class Setting < ActiveRecord::Base
  validates :key, presence: true, uniqueness: true
  validates :value, presence: true

  NO_ROUND = 'no round'

  ##### helpers for specific data types
  def self.get_boolean(key)
    return Setting.find_by_key!(key).value == 'true'
  end

  def self.get_date(key)
    Setting.find_by_key!(key).value.to_date
  end
  #####


  def self.year
    Setting.find_by_key!('year').value.to_i
  end

  def self.cutoff
    self.get_date('cutoff')
  end

  def self.beforeSubmissionsOpen?
    date1 = self.get_date('submissionOpen')
    return self.now < date1
  end

  def self.submissionOpen?
    date1 = self.get_date('submissionOpen')
    date2 = self.get_date('submissionClose')
    return self.between(date1, date2)
  end

  def self.between(date1, date2)
    return (date1..date2).cover?(self.now)
  end

  def self.after(date)
    return self.now >= date
  end

  def self.before(date)
    self.now < date
  end

  def self.anyJudgingRoundActive?
    !self.judgingRoundByDate.nil?
  end

  def self.judgingRound
    self.judgingRoundByDate || NO_ROUND
  end

  def self.nextJudgingRound
    Rubric.stages.keys.each do |round|
      closing_date = self.get_date(round+'JudgingClose')
      if self.before(closing_date)
        return [round, self.get_date(round+'JudgingOpen')]
      end
    end

    # Return quarterfinals by default
    ['quarterfinal', self.get_date('quarterfinalJudgingOpen')]
  end

  def self.judgingRoundActive?(round)
    date1 = self.get_date(round+'JudgingOpen')
    date2 = self.get_date(round+'JudgingClose')
    return self.between(date1, date2)
  end

  def self.scoresVisible?(round)
    self.get_boolean(round+'ScoresVisible')
  end

  def self.scoresVisible
    Rubric.stages.keys.keep_if{ |s| scoresVisible?(s) }
  end

  def self.anyScoresVisible?
    self.scoresVisible.length > 0
  end

  def self.registrationOpen?(userType)
    self.get_boolean(userType+'RegistrationOpen')
  end

  def self.now
    if self.exists?(key: 'todaysDateForTesting')
      self.get_date('todaysDateForTesting')
    else
      Time.now
    end
  end

  private
  def self.judgingRoundByDate
    Rubric.stages.keys.detect{ |s| self.judgingRoundActive?(s) }
  end
end
