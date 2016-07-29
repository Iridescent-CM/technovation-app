module Student
  class AccountsController < StudentController
    include AccountController

    private
    def account
      @account ||= StudentAccount.find_with_token(cookies.fetch(:auth_token) { "" })
    end

    def edit_account_path
      edit_student_account_path
    end

    def account_param_root
      :student_account
    end

    def profile_params
      {
        student_profile_attributes: [
          :id,
          :parent_guardian_email,
          :parent_guardian_name,
          :school_name,
        ],
      }
    end
  end
end
