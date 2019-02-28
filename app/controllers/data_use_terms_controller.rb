class DataUseTermsController < ApplicationController
  def edit
    render :edit
  end

  def update
    account = Account.find_by(email: terms_agreement_params[:terms_agreed])

    account.set_terms_agreed(terms_agreement_params[:terms_agreed])

    render json: AccountSerializer.new(account).serialized_json
  end

  private
  def terms_agreement_params
    params.require(:terms_agreement).permit(:terms_agreed, :email)
  end
end
