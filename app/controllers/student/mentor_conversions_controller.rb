module Student
  class MentorConversionsController < ApplicationController
    layout "application_rebrand"

    def create
      account = Account.find(params[:account_id])
      student_converter_result = StudentToMentorConverter.new(account: account).call

      if student_converter_result.success?
        redirect_to mentor_dashboard_path,
          success: "You are now a mentor!"
      else
        redirect_to student_dashboard_path,
          error: "Something went wrong, please try again or contact us if you need assistance."
      end
    end
  end
end
