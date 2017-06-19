desc "Reset parental consents on Aug 1 of every year"
task reset_parental_consents: :environment do
  if Date.today.month == 8 and Date.today.day == 1
    ParentalConsent.nonvoid.find_each(&:void!)
  end
end
