module Judge
  class AccountsController < JudgeController
    include AccountController

    def profile_params
      {
        judge_profile_attributes: [
          :id,
          :company_name,
          :job_title,
        ],
      }
    end

    private
    def account
      @account ||= JudgeAccount.find_with_token(cookies.fetch(:auth_token) { "" })
    end

    def edit_account_path
      edit_judge_account_path
    end

    def account_param_root
      :judge_account
    end
  end
end
