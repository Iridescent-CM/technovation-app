class Setting < ActiveRecord::Base
  validates :key, presence: true, uniqueness: true
  validates :value, presence: true

  NO_ROUND = 'no round'

  def self.get_boolean(key)
    return Setting.find_by!(key: key).value == 'true'
  rescue ActiveRecord::RecordNotFound
    false
  end

  def self.get_date(key)
    Setting.find_by_key!(key).value.to_date
  rescue ArgumentError, ActiveRecord::RecordNotFound
    nil
  end

  def self.year
    Setting.find_by_key!('year').value.to_i
  end

  def self.cutoff
    self.get_date('cutoff')
  end

  def self.beforeSubmissionsOpen?
    Date.today < Submissions.opening_date
  end

  def self.submissionOpen?
    between(Submissions.opening_date, Submissions.closing_date)
  end

  def self.between(date1, date2)
    return (date1..date2).cover?(Date.today)
  end

  def self.after(date)
    return Date.today >= date
  end

  def self.before(date)
    Date.today < date
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

  # @deprecated
  def self.now
    Rails.logger.warn("Setting.now is deprecated. Use Date.today instead")
    Date.today
  end

  private
  def self.judgingRoundByDate
    Rubric.stages.keys.detect{ |s| self.judgingRoundActive?(s) }
  end
end
