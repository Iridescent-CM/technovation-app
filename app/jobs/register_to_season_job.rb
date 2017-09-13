class RegisterToSeasonJob < ActiveJob::Base
  queue_as :default

  def perform(record)
    season = Season.for(record)
    record.update(seasons: (record.seasons << season.year))
  end
end
