module Mentor
  class SignupsController < ApplicationController
    def new
      @mentor = MentorAccount.new
      expertises
    end

    def create
      @mentor = MentorAccount.new(mentor_params)

      if @mentor.save
        sign_in(@mentor, redirect: mentor_dashboard_path,
                         message: t("controllers.mentor.signups.create.success"))
      else
        expertises
        render :new
      end
    end

    private
    def expertises
      @expertises ||= Expertise.all
    end

    def mentor_params
      params.require(:mentor_account).permit(:email,
                                             :existing_password,
                                             :password,
                                             :password_confirmation,
                                             :date_of_birth,
                                             :first_name,
                                             :last_name,
                                             :city,
                                             :region,
                                             :country,
                                             mentor_profile_attributes: [
                                               :id,
                                               :school_company_name,
                                               :job_title,
                                               { expertise_ids: [] },
                                             ],
                                            )
    end
  end
end
