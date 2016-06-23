module AuthenticationController
  extend ActiveSupport::Concern

  private
  def auth_params
    params.require(:authentication).permit(:email,
                                           :existing_password,
                                           :password,
                                           :password_confirmation,
                                           basic_profile_attributes: [
                                             :id,
                                             :date_of_birth,
                                             :first_name,
                                             :last_name,
                                             :city,
                                             :region,
                                             :country,
                                           ],
                                           student_profile_attributes: [
                                             :id,
                                             :parent_guardian_email,
                                             :parent_guardian_name,
                                             :school_name,
                                           ],
                                           judge_profile_attributes: [
                                             :id,
                                             :company_name,
                                             :job_title,
                                             { scoring_expertise_ids: [] },
                                           ],)
  end
end
