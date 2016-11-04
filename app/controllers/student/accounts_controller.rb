module Student
  class AccountsController < StudentController
    include AccountController

    def profile_params
      [
        :parent_guardian_email,
        :parent_guardian_name,
        :school_name,
      ]
    end

    private
    def account
      @account ||= Account.joins(:student_profile).find_by(auth_token: cookies.fetch(:auth_token))
    end

    def edit_account_path
      edit_student_account_path
    end

    def account_param_root
      :student_account
    end
  end
end
