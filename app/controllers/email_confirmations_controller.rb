class EmailConfirmationsController < ApplicationController
  def new
    if unconfirmed_email = UnconfirmedEmailAddress.find_by(
      confirmation_token: params.fetch(:token)
    )
      account = unconfirmed_email.account
      account.email_confirmed!
      unconfirmed_email.destroy
      SignIn.call(account, self, message: "You have confirmed your new email address!")
    else
      raise ActiveRecord::RecordNotFound.new(
        "Confirmation token not found. Maybe it was already used."
      )
    end
  end
end
