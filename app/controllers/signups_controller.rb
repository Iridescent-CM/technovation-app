class SignupsController < ApplicationController
  include AuthenticationController

  def new
    @signup = signup_class.new
    @signup.build_profiles
    expertises
  end

  def create
    @signup = CreateAuthentication.(auth_params)

    if @signup.valid?
      sign_in(@signup, t('controllers.signups.create.success'))
    else
      @signup.build_profiles
      expertises
      render :new
    end
  end

  private
  def expertises
    @scoring_expertises ||= ScoreCategory.is_expertise
    @expertises ||= Expertise.all
  end

  def signup_class
    Authentication
  end
end
