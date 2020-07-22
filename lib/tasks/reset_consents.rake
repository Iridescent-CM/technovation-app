desc "Reset parental consents and mentor/chapter ambassador waivers on Oct 1 of every year"
task reset_consents: :environment do
  if Date.today.month == Season::START_MONTH and
      Date.today.day == Season::START_DAY
    ConsentWaiver.nonvoid.find_each(&:void!)
  end
end
