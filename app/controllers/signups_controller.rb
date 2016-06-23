class SignupsController < ApplicationController
  include AuthenticationController

  def new
    @signup = signup_class.new
    build_profiles
    expertises
  end

  def create
    @signup = CreateAuthentication.(auth_params)

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

  def signup_class
    Authentication
  end
end
