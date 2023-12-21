require "reset_vulnerable_passwords"

desc "Reset the vulnerable passwords due to the registration bug"
task reset_vulnerable_passwords: :environment do
  ResetVulnerablePasswords.perform!
end
