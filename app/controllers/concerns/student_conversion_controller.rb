module StudentConversionController
  extend ActiveSupport::Concern

  def create
    profile = StudentProfile.find(params.fetch(:student_profile_id))

    account = profile.account

    account.create_mentor_profile!({
      school_company_name: profile.school_name,
      job_title: "Technovation Almunus",
    })

    profile.account_id = nil
    profile.save!

    redirect_to [current_scope, :participant, id: account.to_param],
      success: "#{account.name} is now a mentor"
  end
end
