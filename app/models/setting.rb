class Setting < ActiveRecord::Base
  validates :key, presence: true, uniqueness: true
  validates :value, presence: true

  def self.year
    Setting.find_by_key!('year').value.to_i
  end
  def self.cutoff
    Setting.find_by_key!('cutoff').value.to_date
  end
  def self.submissionOpen?
  	!Setting.find_by_key!('submissionOpen?').value == 'true'
  end
end
