module HonorCodeAgreementController
  extend ActiveSupport::Concern

  def new
    @honor_code_agreement = current_account.build_honor_code_agreement
    render template: 'honor_code_agreements/new'
  end

  def create
    @honor_code_agreement = current_account.build_honor_code_agreement(
      honor_code_agreement_params
    )

    if @honor_code_agreement.save
      flash.now[:success] =
        "Thank you for your promise. Now get out there and show us what you got!"

      redirect_to cookies.delete(:redirected_from) ||
        send("#{current_scope}_dashboard_path")
    else
      render template: 'honor_code_agreements/new'
    end
  end

  def show
    @honor_code_agreement = current_account.honor_code_agreement
    render template: 'honor_code_agreements/show'
  end

  private
  def honor_code_agreement_params
    params.require(:honor_code_agreement).permit(
      :agreement_confirmed,
      :electronic_signature
    )
  end
end
