class TermsAgreementsController < ApplicationController
  layout "application_rebrand"

  def new
  end

  def create
    if terms_agreement_params[:agree] == "1"
      current_account.set_terms_agreed(terms_agreement_params[:agree])

      redirect_to public_dashboard_path
    else
      flash[:error] = "You must agree to the data terms"
      render :new
    end
  end

  private

  def terms_agreement_params
    params.require(:terms).permit(:agree)
  end
end
