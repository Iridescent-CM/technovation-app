class SignupsController < ApplicationController
  def new
    @signup = Signup.new
    expertises
  end

  def create
    @signup = CreateSignup.(signup_params)

    if @signup.valid?
      sign_in(@signup, t('controllers.signups.create.success'))
    else
      expertises
      render :new
    end
  end

  private
  def expertises
    @expertises ||= ScoreCategory.all
  end

  def signup_params
    params.require(:signup).permit(:email,
                                   :password,
                                   :password_confirmation,
                                   expertise_ids: [])
  end
end
