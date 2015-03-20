class Setting < ActiveRecord::Base
  validates :key, presence: true, uniqueness: true
  validates :value, presence: true

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

  def self.anyJudgingRoundActive?
    return Rubric.stages.keys.keep_if{ |s| self.judgingRoundActive?(s)}.length > 0
  end

  def self.judgingRoundActive
    ## return the active judging round
    active = Rubric.stages.keys.keep_if{ |s| self.judgingRoundActive? (s)}
    return active.empty? ? 'no round' : active[0]
  end

  def self.nextJudgingRound
    date = self.get_date(self.stage + 'JudgingOpen')
    return [self.stage, date]
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
    return self.scoresVisible.length > 0
  end

  def self.stage
    for stage in Rubric.stages.keys
      if judgingRoundActive?(stage)
        return stage
      end
    end

    ## if no stages are active returns 'quarterfinal'
    return 'quarterfinal'
  end

  def self.now
    ## for testing only
    self.get_date('todaysDateForTesting')

    ## todo change to 
#    Time.now
  end
end
