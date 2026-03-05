desc "Update existing parental/guardian and media consent files with en locale"
task update_locale_on_all_existing_consent_forms: :environment do
  ParentalConsent.where(locale: nil).update_all(locale: "en")
  MediaConsent.where(locale: nil).update_all(locale: "en")
end
