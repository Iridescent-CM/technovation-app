module AccountController
  extend ActiveSupport::Concern

  private
  def account_params
    params.require(account_param_root).permit(
      :email,
      :existing_password,
      :password,
      :password_confirmation,
      :date_of_birth,
      :first_name,
      :last_name,
      :city,
      :state_province,
      :country,
      profile_params,
    )
=begin
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
=end
  end

  def account_param_root
    :account
  end

  def profile_params
    { }
  end
end
