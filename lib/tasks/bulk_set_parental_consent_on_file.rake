desc "Bulk set parental consent on file"
task bulk_set_parental_consent_on_file: :environment do |task, args|
  puts "Starting bulk set parental consent on file"

  args.extras.each do |email_address|
    account = Account.find_by(email: email_address)

    if account.blank?
      puts "#{email_address} could not be found"
    elsif account.student_profile.blank?
      puts "#{email_address} is not a student"
    elsif !account.current_season?
      puts "#{email_address} is not registered to the current season"
    elsif account.student_profile.parental_consent.nil?
      puts "Parental consent for #{email_address} could not be found"
    elsif account.student_profile.parental_consent.signed?
      puts "Parental consent for #{email_address} already signed"
    else
      parental_consent = account.student_profile.parental_consent

      parental_consent.update(
        status: ParentalConsent.statuses[:signed],
        electronic_signature: ConsentForms::PARENT_GUARDIAN_NAME_FOR_A_PAPER_CONSENT
      )

      puts "Set parental consent on file for #{email_address} - Account ID: #{account.id}"
    end
  end
end
