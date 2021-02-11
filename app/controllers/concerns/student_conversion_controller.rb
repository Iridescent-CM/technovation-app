module StudentConversionController
  extend ActiveSupport::Concern

  def create
    account = StudentProfile.find(params.fetch(:student_profile_id)).account
    student_converter_result = StudentToMentorConverter.new(account: account).call

    redirect_to [current_scope, :participant, id: account.to_param],
      flash: student_converter_result.message
  end
end
