class Setting < ActiveRecord::Base
  before_validation -> { self.value = value.to_s }
  validates :key, presence: true, uniqueness: true
  validates :value, presence: true

  def self.allow_ineligibility_logic_for_students
    get_boolean('allow_ineligibility_logic_for_students')
  end

  def self.allow_ineligibility_logic
    get_boolean('allow_ineligibility_logic')
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

  def self.between(date1, date2)
    (date1..date2).cover?(Date.today)
  end

  def self.after(date)
    Date.today >= date
  end

  def self.anyJudgingRoundActive?
    !!judgingRoundByDate
  end

  def self.judgingRound
    judgingRoundByDate || 'no_round'
  end

  def self.nextJudgingRound
    Rubric.stages.keys.each do |round|
      closing_date = self.get_date(round+'JudgingClose')
      if Date.today < closing_date
        return [round, self.get_date(round+'JudgingOpen')]
      end
    end

    # Return quarterfinals by default
    ['quarterfinal', self.get_date('quarterfinalJudgingOpen')]
  end

  def self.judgingRoundActive?(round)
    date1 = get_date(round+'JudgingOpen')
    date2 = get_date(round+'JudgingClose')
    between(date1, date2)
  end

  def self.scoresVisible?(round)
    self.get_boolean("#{round}ScoresVisible")
  end

  def self.scoresVisible
    Rubric.stages.keys.select { |s| scoresVisible?(s) }
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

  def self.reset(key, value)
    attrs = { key: key.to_s, value: value.to_s }

    if setting = find_by(key: key)
      setting.update_attributes(attrs)
    else
      create!(attrs)
    end
  end

  def self.pre_program_survey_visible?
    Setting.find_by_key!('pre_program_survey').value == 'true'
  end

  def self.post_program_survey_visible?
    Setting.find_by_key!('post_program_survey').value == 'true'
  end

  private
  def self.judgingRoundByDate
    Rubric.stages.keys.detect { |s| judgingRoundActive?(s) }
  end

  # @deprecating
  def self.get_boolean(key)
    Rails.logger.warn("Setting.get_boolean will soon be removed!")
    %w(t true).include?(Setting.find_by!(key: key).value)
  rescue ActiveRecord::RecordNotFound
    false
  end
end
