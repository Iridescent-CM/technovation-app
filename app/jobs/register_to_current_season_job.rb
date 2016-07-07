class RegisterToCurrentSeasonJob < ActiveJob::Base
  queue_as :default

  def perform(account)
    SeasonRegistration.register(account)
  end
end
