class TermsAgreementsController < ApplicationController
  layout "application_rebrand"
  def edit
    @account = current_account

    if @account.terms_agreed?
      redirect_to send("#{current_account.scope_name}_dashboard_path"),
        error: t("controllers.application.unauthorized") and return
    end

    render :edit
  end

  def update
    if current_account.set_terms_agreed(terms_agreement_params[:terms_agreed])
      redirect_to send("#{current_account.scope_name}_dashboard_path")
    else
      @account = current_account
      render :edit
    end
  end

  private
  def terms_agreement_params
    params.require(:account).permit(:terms_agreed)
  end
end
