class SignupsController < ApplicationController
  def new
    @signup = signup_class.new
    expertises
  end

  def create
    if (@signup = CreateJudge.(signup_params)).valid?
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
    params.require(:authentication).permit(:email,
                                           :password,
                                           :password_confirmation,
                                           expertise_ids: [])
  end

  def signup_class
    Authentication
  end
end
