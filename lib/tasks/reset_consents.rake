desc "Reset parental consents and waivers on Aug 1 of every year"
task reset_consents: :environment do
  if Date.today.month == 8 and Date.today.day == 1
    ParentalConsent.nonvoid.find_each(&:void!)
    ConsentWaiver.nonvoid.find_each(&:void!)
  end
end
