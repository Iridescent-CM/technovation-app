class Setting < ActiveRecord::Base
  def self.year
    Setting.find_by_key('year').value.to_i
  end
  def self.cutoff
    Setting.find_by_key('cutoff').value.to_date
  end
end
