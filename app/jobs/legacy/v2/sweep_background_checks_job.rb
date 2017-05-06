module Legacy
  module V2
    class SweepBackgroundChecksJob < ActiveJob::Base
      queue_as :default

      def perform(*statuses)
        statuses.each do |status|
          SweepBackgroundChecks.(status)
        end
      end
    end
  end
end
