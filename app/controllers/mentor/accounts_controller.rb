module Mentor
  class AccountsController < MentorController
    include AccountController

    private
    def account
      @account ||= MentorAccount.find_with_token(cookies.fetch(:auth_token) { "" })
    end

    def after_update_redirect_path
      mentor_account_path
    end

    def edit_account_path
      edit_mentor_account_path
    end

    def account_param_root
      :mentor_account
    end

    def profile_params
      {
        mentor_profile_attributes: [
          :id,
          :school_company_name,
          :job_title,
          { expertise_ids: [] },
        ],
      }
    end
  end
end
