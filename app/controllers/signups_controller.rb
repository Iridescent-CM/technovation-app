class SignupsController < ApplicationController
  def new
    @signup = signup_class.new
    build_profiles
    expertises
  end

  def create
    @signup = CreateAuthentication.(signup_params)

    if @signup.valid?
      sign_in(@signup, t('controllers.signups.create.success'))
    else
      build_profiles
      expertises
      render :new
    end
  end

  private
  def expertises
    @expertises ||= ScoreCategory.all
  end

  def build_profiles
    @signup.build_basic_profile if @signup.basic_profile.nil?
    @signup.build_student_profile if @signup.student_profile.nil?
    @signup.build_judge_profile if @signup.judge_profile.nil?
  end

  def signup_params
    params.require(:authentication).permit(:email,
                                           :password,
                                           :password_confirmation,
                                           basic_profile_attributes: [
                                             :date_of_birth,
                                             :first_name,
                                             :last_name,
                                             :city,
                                             :region,
                                             :country,
                                           ],
                                           student_profile_attributes: [
                                             :parent_guardian_email,
                                             :parent_guardian_name,
                                             :school_name,
                                           ],
                                           judge_profile_attributes: [
                                             :company_name,
                                             :job_title,
                                             { expertise_ids: [] },
                                           ],)
  end

  def signup_class
    Authentication
  end
end
