module StudentConversionController
  extend ActiveSupport::Concern

  def create
    account = StudentProfile.find(params.fetch(:student_profile_id)).account
    student_converter_result = StudentToMentorConverter.new(account: account).call

    redirect_to send("#{current_scope}_participant_path", id: account.to_param),
      flash: student_converter_result.message
  end
end
