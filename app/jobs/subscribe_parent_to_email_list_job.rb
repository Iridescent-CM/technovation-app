class SubscribeParentToEmailListJob < ActiveJob::Base
  queue_as :default

  def perform(student_profile_id:)
    student_profile = StudentProfile.find(student_profile_id)
    faux_parent_account = FauxAccount.new(
      methods_with_return_values: {
        email: student_profile.parent_guardian_email,
        full_name: student_profile.parent_guardian_name
      }
    )

    Mailchimp::MailingList.new.subscribe(account: faux_parent_account, profile_type: "parent")
  end
end
