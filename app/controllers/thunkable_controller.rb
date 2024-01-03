class ThunkableController < ApplicationController
  before_action :unauthenticated!, if: -> {
    !current_account.authenticated?
  }

  def show
    render "general_info/get_started_with_thunkable"
  end

  private

  def unauthenticated!
    save_redirected_path

    redirect_to signin_path,
      notice: t("controllers.application.generic_unauthenticated")
  end
end
