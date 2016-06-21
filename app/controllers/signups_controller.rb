class SignupsController < ApplicationController
  def new
    @signup = signup_class.new
    @signup.build_student_profile
    @signup.build_judge_profile
    expertises
  end

  def create
    @signup = CreateSignup.(signup_params)

    if @signup.valid?
      sign_in(@signup, t('controllers.signups.create.success'))
    else
      @signup.build_student_profile if @signup.student_profile.blank?
      @signup.build_judge_profile if @signup.judge_profile.blank?
      expertises
      render :new
    end
  end

  private
  def expertises
    @expertises ||= ScoreCategory.all
  end

  def signup_params
    params.require(:authentication).permit(:email,
                                           :password,
                                           :password_confirmation,
                                           :registration_role,
                                           student_profile_attributes: [
                                             :parent_guardian_email,
                                             :date_of_birth,
                                           ],
                                           judge_profile_attributes: {
                                             expertise_ids: [],
                                           },)
  end

  def signup_class
    Authentication
  end
end
