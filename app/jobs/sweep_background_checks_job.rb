class SweepBackgroundChecksJob < ActiveJob::Base
  queue_as :default

  def perform(*statuses)
    statuses.each do |status|
      SweepBackgroundChecks.call(status)
    end
  end
end
