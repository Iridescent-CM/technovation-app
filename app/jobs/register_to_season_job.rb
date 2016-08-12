class RegisterToSeasonJob < ActiveJob::Base
  queue_as :default

  def perform(record)
    season = Season.for(record)
    SeasonRegistration.register(record, season)
  end
end
