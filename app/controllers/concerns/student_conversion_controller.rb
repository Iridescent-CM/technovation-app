module StudentConversionController
  extend ActiveSupport::Concern

  def create
    profile = StudentProfile.find(params.fetch(:student_profile_id))
    account = profile.account

    CreateMentorProfile.(account)

    redirect_to [current_scope, :participant, id: account.to_param],
      success: "#{account.name} is now a mentor"
  end
end
