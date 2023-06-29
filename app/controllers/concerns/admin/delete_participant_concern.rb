module Admin::DeleteParticipantConcern
  extend ActiveSupport::Concern

  def destroy
    account = Account.find(params[:id])

    DeleteAccountFromEmailListJob.perform_later(email_address: account.email)
    account.destroy

    redirect_to(
      send("#{current_scope}_participants_path"),
      success: "#{account.name} was removed from Technovation Girls"
    )
  end
end
