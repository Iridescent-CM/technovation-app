module Mentor
  class AccountsController < MentorController
    include AccountController

    before_filter :expertises

    private
    def account
      @account ||= MentorAccount.find_with_token(cookies.fetch(:auth_token) { "" })
    end

    def expertises
      @expertises ||= Expertise.all
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
          :bio,
          :accepting_team_invites,
          :virtual,
          { expertise_ids: [] },
        ],
      }
    end
  end
end
