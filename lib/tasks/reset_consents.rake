desc "Reset parental consents and mentor/RA waivers on Oct 1 of every year"
task reset_consents: :environment do
  if Date.today.month == Season.switch_month and
      Date.today.day == Season.switch_day
    ParentalConsent.nonvoid.find_each(&:void!)
    ConsentWaiver.nonvoid.find_each(&:void!)
  end
end
