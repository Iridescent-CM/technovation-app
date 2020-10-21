class UpdateParentOnEmailListJob < ActiveJob::Base
  queue_as :default

  def perform(student_profile_id:, currently_subscribed_as:)
    student_profile = StudentProfile.find(student_profile_id)
    faux_parent_account = FauxAccount.new(
      methods_with_return_values: {
        email: student_profile.parent_guardian_email,
        full_name: student_profile.parent_guardian_name
      }
    )

    Mailchimp::MailingList.new.update(
      account: faux_parent_account,
      currently_subscribed_as: currently_subscribed_as
    )
  end
end
