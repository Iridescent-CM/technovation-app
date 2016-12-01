class InterruptionsController < ApplicationController
  before_action :unauthenticated!, if: -> {
    not current_account.authenticated?
  }

  def index
    # load .errors
    current_account.valid?
    current_account.profile_valid?

    render template: "interruptions/#{params[:issue]}_interruption"
  end

  private
  def unauthenticated!
    save_redirected_path

    redirect_to signin_path,
      notice: t("controllers.application.generic_unauthenticated")
  end
end
