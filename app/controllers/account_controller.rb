module AccountController
  extend ActiveSupport::Concern

  private
  def account_params
    params.require(:account).permit(:email,
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
                                    coach_profile_attributes: [
                                      :id,
                                      :school_company_name,
                                      :job_title,
                                      { expertise_ids: [] },
                                    ],
                                    judge_profile_attributes: [
                                      :id,
                                      :company_name,
                                      :job_title,
                                      { scoring_expertise_ids: [] },
                                    ],
                                    mentor_profile_attributes: [
                                      :id,
                                      :school_company_name,
                                      :job_title,
                                      { expertise_ids: [] },
                                    ],
                                    student_profile_attributes: [
                                      :id,
                                      :parent_guardian_email,
                                      :parent_guardian_name,
                                      :school_name,
                                    ],
                                  )
  end
end
