desc "Update Salesforce contacts"
task update_salesforce_contacts: :environment do |_, args|
  args.extras.each do |arg|
    wait_time = 0

    arg.split(",").each do |account_id|
      account = Account.find(account_id)

      if !account.is_admin?
        profile_type = account.student_profile.present? ? "student" : nil

        puts "Upserting contact info for account id: #{account_id}"
        CRM::UpsertContactInfoJob.perform_later(
          account_id: account.id,
          profile_type: profile_type
        )

        wait_time += 15

        if account.student_profile.present?
          puts "Upserting student program info for account id: #{account_id}"

          CRM::UpsertProgramInfoJob.set(wait: wait_time.seconds).perform_later(
            account_id: account.id,
            profile_type: "student"
          )

          wait_time += 15
        end

        if account.mentor_profile.present?
          puts "Upserting mentor program info for account id: #{account_id}"

          CRM::UpsertProgramInfoJob.set(wait: wait_time.seconds).perform_later(
            account_id: account.id,
            profile_type: "mentor"
          )

          wait_time += 15
        end

        if account.judge_profile.present?
          puts "Upserting judge program info for account id: #{account_id}"

          CRM::UpsertProgramInfoJob.set(wait: wait_time.seconds).perform_later(
            account_id: account.id,
            profile_type: "judge"
          )

          wait_time += 15
        end

        if account.chapter_ambassador_profile.present?
          puts "Upserting chapter ambassador program info for account id: #{account_id}"

          CRM::UpsertProgramInfoJob.set(wait: wait_time.seconds).perform_later(
            account_id: account.id,
            profile_type: "chapter ambassador"
          )
        end
      else
        puts "Skipping admin account: #{account_id}"
      end
    end
  end
end
