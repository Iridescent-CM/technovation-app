class BgCheckController < ApplicationController
  before_action :check_user
  skip_before_filter :verify_consent
  skip_before_filter :verify_bg_check

  def index
  end

  def update
    current_user.bg_check_id = 'bbb'
    if current_user.save
      flash[:notice] = 'Thank you for submitting your background check'
      redirect_to :root
    end
  end

  def self.bg_check_required?(user)
    !user.nil? and user.mentor? and user.bg_check_id.nil?
  end


  private
  def check_user
    @user = current_user
    authorize @user
    if !BgCheckController.bg_check_required?(@user)
      redirect_to :root
    end
  end

  def user_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :birthday,
      :postal_code,
    )
  end

end
